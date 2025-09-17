import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:management/core/services/app_env_service.dart';
import 'package:management/modules/auth/models/auth_session.dart';
import 'package:management/modules/auth/models/auth_tenant_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppAuthService {
  AppAuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  static const _kLastLoginAt = 'auth.lastLoginAt';
  static const _kRememberUntil = 'auth.rememberUntil';
  static const _sessionDays = 7;

  static const _kTenantId = 'auth.tenantId';
  static const _kTenantLicense = 'auth.tenantLicenseUntil';
  static const _kTenantName = 'auth.tenantName';
  static const _kTenantDocument = 'auth.tenantDocument';
  static const _kTenantActive = 'auth.tenantActive';
  static const _kTenantCreatedAt = 'auth.tenantCreatedAt';
  static const _kTenantUpdatedAt = 'auth.tenantUpdatedAt';

  static const _kTenantRole = 'auth.tenantRole';
  static const _kTenantIsAdmin = 'auth.tenantIsAdmin';

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  AuthSession? _authSession;
  AuthSession? get authSession => _authSession;

  Stream<User?> get onAuthStateChanged => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<bool> get isSessionValid async {
    final prefs = await SharedPreferences.getInstance();
    final untilMillis = prefs.getInt(_kRememberUntil);
    final untilTenantLicense = prefs.getInt(_kTenantLicense);

    if (_auth.currentUser == null) return false;
    if (untilMillis == null || untilTenantLicense == null) return false;

    final now = DateTime.now();
    final until = DateTime.fromMillisecondsSinceEpoch(untilMillis);
    final untilLicense = DateTime.fromMillisecondsSinceEpoch(
      untilTenantLicense,
    );
    return now.isBefore(until) && now.isBefore(untilLicense);
  }

  Future<void> init() async {
    if (_auth.currentUser == null) {
      _authSession = null;
      return;
    }

    final valid = await isSessionValid;
    if (!valid) {
      await signOut();
      return;
    }

    try {
      final restored = await _restoreAuthSessionFromCache();
      if (restored != null) {
        _authSession = restored;
      } else {
        await signOut();
      }
    } catch (e, s) {
      log('[AppAuthService::init] - restore error: $e\n$s');
      await signOut();
    }
  }

  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    await _saveSession();

    try {
      final tenant = await _resolveAndValidateTenant(cred.user!);
      _authSession = AuthSession(user: cred.user!, tenant: tenant);
      return _authSession!;
    } on Exception catch (e) {
      log(e.toString());
      await signOut();
      rethrow;
    }
  }

  Future<AuthSession?> signInWithGoogle() async {
    await _googleSignIn.initialize(
      serverClientId: AppEnvService.instance.googleServerClientId,
    );

    final account = await _googleSignIn.authenticate();
    final idToken = account.authentication.idToken;
    final authz = await account.authorizationClient.authorizationForScopes(
      const ['email', 'profile'],
    );
    final accessToken = authz?.accessToken;

    final credential = GoogleAuthProvider.credential(
      idToken: idToken,
      accessToken: accessToken,
    );

    final cred = await _auth.signInWithCredential(credential);
    await _saveSession();

    try {
      final tenant = await _resolveAndValidateTenant(cred.user!);
      _authSession = AuthSession(user: cred.user!, tenant: tenant);
      return _authSession!;
    } on Exception catch (e) {
      log(e.toString());
      await signOut();
      rethrow;
    }
  }

  Future<void> resetPassword({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kLastLoginAt);
    await prefs.remove(_kRememberUntil);

    await prefs.remove(_kTenantId);
    await prefs.remove(_kTenantLicense);
    await prefs.remove(_kTenantName);
    await prefs.remove(_kTenantDocument);
    await prefs.remove(_kTenantActive);
    await prefs.remove(_kTenantCreatedAt);
    await prefs.remove(_kTenantUpdatedAt);

    await prefs.remove(_kTenantIsAdmin);
    await prefs.remove(_kTenantRole);

    _authSession = null;

    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  Future<void> _saveSession() async {
    final now = DateTime.now();
    final until = now.add(const Duration(days: _sessionDays));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kLastLoginAt, now.millisecondsSinceEpoch);
    await prefs.setInt(_kRememberUntil, until.millisecondsSinceEpoch);
  }

  Future<void> _persistTenantCache({
    required String tenantId,
    required DateTime licenseUntil,
    required String name,
    required String document,
    required bool active,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kTenantId, tenantId);
    await prefs.setInt(_kTenantLicense, licenseUntil.millisecondsSinceEpoch);
    await prefs.setString(_kTenantName, name);
    await prefs.setString(_kTenantDocument, document);
    await prefs.setBool(_kTenantActive, active);
    await prefs.setInt(_kTenantCreatedAt, createdAt.millisecondsSinceEpoch);
    await prefs.setInt(_kTenantUpdatedAt, updatedAt.millisecondsSinceEpoch);
  }

  Future<AuthSession?> _restoreAuthSessionFromCache() async {
    final prefs = await SharedPreferences.getInstance();

    final tenantId = prefs.getString(_kTenantId);
    final name = prefs.getString(_kTenantName);
    final document = prefs.getString(_kTenantDocument);
    final active = prefs.getBool(_kTenantActive);
    final createdAtMs = prefs.getInt(_kTenantCreatedAt);
    final updatedAtMs = prefs.getInt(_kTenantUpdatedAt);
    final licMs = prefs.getInt(_kTenantLicense);

    if (_auth.currentUser == null ||
        tenantId == null ||
        name == null ||
        document == null ||
        active == null ||
        createdAtMs == null ||
        updatedAtMs == null ||
        licMs == null) {
      return null;
    }

    final tenantSession = AuthTenantSession(
      name: name,
      active: active,
      document: document,
      tenantId: tenantId,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtMs),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAtMs),
      licenseUntil: DateTime.fromMillisecondsSinceEpoch(licMs),
    );

    return AuthSession(user: _auth.currentUser!, tenant: tenantSession);
  }

  Future<AuthTenantSession> _resolveAndValidateTenant(User firebaseUser) async {
    final emailLower = (firebaseUser.email ?? '').trim().toLowerCase();

    final usersSnap = await _firestore
        .collectionGroup('users')
        .where('email', isEqualTo: emailLower)
        .where('active', isEqualTo: true)
        .limit(1)
        .get();

    if (usersSnap.docs.isEmpty) {
      throw Exception('E-mail não está vinculado a nenhuma empresa ativa.');
    }

    final userDocSnap = usersSnap.docs.first; // tenants/{tenantId}/users/{uid}

    final tenantRef = userDocSnap.reference.parent.parent!;
    final tenantId = tenantRef.id;

    final tenantDoc = await _firestore
        .collection('tenants')
        .doc(tenantId)
        .get();
    if (!tenantDoc.exists) throw Exception('Empresa não encontrada.');
    final t = tenantDoc.data()!;

    final name = (t['name'] ?? '-') as String;
    final document = (t['document'] ?? '-') as String;
    final createdAt = (t['createdAt'] as Timestamp).toDate();
    final updatedAt = (t['updatedAt'] as Timestamp).toDate();

    final active = (t['active'] ?? false) as bool;
    if (!active) throw Exception('Empresa inativa.');

    final licenseTs = t['licenseUntil'];
    if (licenseTs == null) {
      throw Exception('Licença ausente para esta empresa.');
    }
    final licenseUntil = (licenseTs as Timestamp).toDate();
    if (licenseUntil.isBefore(DateTime.now())) {
      throw Exception('Licença expirada em ${licenseUntil.toIso8601String()}.');
    }

    await _persistTenantCache(
      tenantId: tenantId,
      licenseUntil: licenseUntil,
      name: name,
      document: document,
      active: active,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );

    // final userData = userDocSnap.data();
    // final role = (userData['role'] ?? 'USER') as String;
    // final isAdmin = role == 'MASTER';

    return AuthTenantSession(
      name: name,
      active: active,
      document: document,
      tenantId: tenantId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      licenseUntil: licenseUntil,
    );
  }
}
