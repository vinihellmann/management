import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:management/modules/auth/models/auth_session.dart';
import 'package:management/modules/auth/models/enums/auth_status.dart';
import 'package:management/modules/auth/models/enums/user_role.dart';
import 'package:management/modules/auth/models/member_profile.dart';
import 'package:management/modules/auth/models/tenant_meta.dart';
import 'package:management/shared/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  AuthController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  AuthStatus _status = AuthStatus.bootstrapping;
  AuthStatus get status => _status;

  AuthSession? _session;
  AuthSession? get session => _session;

  StreamSubscription<User?>? _authSub;

  static const _kLastLoginAt = 'last_login_at';
  static const _kLastTenantCnpj = 'last_tenant_cnpj';
  static const _kCachedSession = 'cached_session_v1';

  bool _suppressOnAuthChangeOnce = false;

  Future<void> init() async {
    _authSub?.cancel();
    _authSub = _auth.authStateChanges().listen((_) => _onAuthChanged());

    await _onAuthChanged();
  }

  Future<void> _onAuthChanged() async {
    if (_suppressOnAuthChangeOnce) return;

    final user = _auth.currentUser;

    if (user == null) {
      _session = null;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final lastLoginMs = prefs.getInt(_kLastLoginAt);

    if (lastLoginMs != null) {
      final loggedAt = DateTime.fromMillisecondsSinceEpoch(lastLoginMs);

      if (DateTime.now().difference(loggedAt).inDays >= 7) {
        await signOut();
        return;
      }
    }

    final cnpj = prefs.getString(_kLastTenantCnpj);
    if (cnpj == null || cnpj.isEmpty) {
      await signOut();
      return;
    }

    try {
      final metaSnap = await _db.doc('companies/$cnpj').get();
      if (!metaSnap.exists) {
        throw FirebaseAuthException(code: 'tenant-not-found');
      }

      final metaData = metaSnap.data() as Map<String, dynamic>;

      final tenant = TenantMeta(
        cnpj: cnpj,
        name: (metaData['name'] as String?) ?? cnpj,
        active: (metaData['active'] as bool?) ?? false,
        licenseUntil: (metaData['licenseUntil'] as Timestamp?)?.toDate(),
      );

      final memberSnap = await _db
          .doc('companies/$cnpj/members/${user.uid}')
          .get();
      if (!memberSnap.exists) {
        throw FirebaseAuthException(code: 'user-not-found-in-tenant');
      }

      final m = memberSnap.data() as Map<String, dynamic>;
      final member = MemberProfile(
        uid: user.uid,
        role: UserRoleX.fromString((m['role'] as String?) ?? 'USER'),
        active: (m['active'] as bool?) ?? false,
        email: m['email'] as String,
        displayName: m['displayName'] as String,
      );

      final last = DateTime.fromMillisecondsSinceEpoch(
        lastLoginMs ?? DateTime.now().millisecondsSinceEpoch,
      );

      final newSession = AuthSession(
        firebaseUser: user,
        tenant: tenant,
        member: member,
        loggedAt: last,
      );

      await _saveCache(newSession);

      if (!tenant.licenseValid || !member.active) {
        _session = newSession;
        _status = AuthStatus.blocked;
      } else {
        _session = newSession;
        _status = AuthStatus.authenticated;
      }

      notifyListeners();
      return;
    } catch (_) {
      final cached = await _loadCache();

      if (cached != null) {
        if (cached.isExpired) {
          await signOut();
          return;
        }

        if (!cached.tenant.licenseValid || !cached.member.active) {
          _session = cached;
          _status = AuthStatus.blocked;
          notifyListeners();
          return;
        }

        _session = cached;
        _status = AuthStatus.authenticated;
        notifyListeners();
        return;
      }

      _session = null;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return;
    }
  }

  Future<String?> signIn(String cgc, String email, String password) async {
    try {
      final normalized = Utils.normalizeCgc(cgc);

      _suppressOnAuthChangeOnce = true;
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_kLastLoginAt, DateTime.now().millisecondsSinceEpoch);
      await prefs.setString(_kLastTenantCnpj, normalized);

      final err = await _postLoginValidateAndBuildSession(normalized);
      if (err != null) {
        await _auth.signOut();
        _session = null;
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        return err;
      }

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Erro de autenticação';
    } catch (e) {
      return 'Falha ao entrar: $e';
    } finally {
      Future.microtask(() => _suppressOnAuthChangeOnce = false);
    }
  }

  Future<String?> _postLoginValidateAndBuildSession(String cnpj) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return 'Usuário não autenticado.';

      final metaSnap = await _db.doc('companies/$cnpj').get();
      if (!metaSnap.exists) return 'Empresa não encontrada.';
      final metaData = metaSnap.data() as Map<String, dynamic>;

      final tenant = TenantMeta(
        cnpj: cnpj,
        name: (metaData['name'] as String?) ?? cnpj,
        active: (metaData['active'] as bool?) ?? false,
        licenseUntil: (metaData['licenseUntil'] as Timestamp?)?.toDate(),
      );

      final memberSnap = await _db
          .doc('companies/$cnpj/members/${user.uid}')
          .get();

      if (!memberSnap.exists) {
        return 'Usuário não encontrado na empresa informada.';
      }

      final m = memberSnap.data() as Map<String, dynamic>;
      final member = MemberProfile(
        uid: user.uid,
        role: UserRoleX.fromString((m['role'] as String?) ?? 'USER'),
        active: (m['active'] as bool?) ?? false,
        email: (m['email'] as String?) ?? user.email ?? '',
        displayName: (m['displayName'] as String?) ?? user.displayName ?? '',
      );

      final prefs = await SharedPreferences.getInstance();
      final lastLoginMs = prefs.getInt(_kLastLoginAt);
      final last = DateTime.fromMillisecondsSinceEpoch(
        lastLoginMs ?? DateTime.now().millisecondsSinceEpoch,
      );

      final newSession = AuthSession(
        firebaseUser: user,
        tenant: tenant,
        member: member,
        loggedAt: last,
      );

      await _saveCache(newSession);

      if (!tenant.licenseValid) {
        _session = newSession;
        _status = AuthStatus.blocked;
      } else if (!member.active) {
        return 'Usuário desativado nessa empresa.';
      } else {
        _session = newSession;
        _status = AuthStatus.authenticated;
      }

      notifyListeners();
      return null;
    } catch (e) {
      return 'Falha ao validar empresa/usuário: $e';
    }
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await _auth.signOut();

    _session = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<void> _saveCache(AuthSession s) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kCachedSession, jsonEncode(s.toMap()));
  }

  Future<AuthSession?> _loadCache() async {
    final prefs = await SharedPreferences.getInstance();

    final raw = prefs.getString(_kCachedSession);
    if (raw == null) return null;

    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final data = jsonDecode(raw) as Map<String, dynamic>;
      return AuthSession.fromMap(user, data);
    } catch (_) {
      return null;
    }
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}
