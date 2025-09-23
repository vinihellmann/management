import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:management/core/constants/app_storage_names.dart';
import 'package:management/core/services/app_env_service.dart';
import 'package:management/core/services/app_secure_storage_service.dart';
import 'package:management/modules/auth/enums/auth_role_enum.dart';
import 'package:management/modules/auth/models/auth_session.dart';
import 'package:management/modules/auth/models/auth_tenant_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppAuthService {
  AppAuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  AuthSession? _authSession;
  AuthSession? get authSession => _authSession;

  Stream<User?> get onAuthStateChanged => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<bool> get isSessionValid async {
    final prefs = await SharedPreferences.getInstance();
    final untilMillis = prefs.getInt(AppStorageNames.kRememberUntil);
    final untilTenantLicense = prefs.getInt(AppStorageNames.kTenantLicense);

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

      final prefs = await SharedPreferences.getInstance();
      final roleStr = prefs.getString(AppStorageNames.kUserRole) ?? 'USER';
      final userRole = UserRole.fromString(roleStr);

      _authSession = AuthSession(
        user: cred.user!,
        tenant: tenant,
        userRole: userRole,
      );

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

      final prefs = await SharedPreferences.getInstance();
      final roleStr = prefs.getString(AppStorageNames.kUserRole) ?? 'USER';
      final userRole = UserRole.fromString(roleStr);

      _authSession = AuthSession(
        user: cred.user!,
        tenant: tenant,
        userRole: userRole,
      );

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
    await prefs.clear();

    await AppSecureStorageService.remove(AppStorageNames.kUserRole);

    _authSession = null;

    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  Future<void> _saveSession() async {
    final now = DateTime.now();
    final until = now.add(const Duration(days: AppStorageNames.kSessionDays));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      AppStorageNames.kLastLoginAt,
      now.millisecondsSinceEpoch,
    );
    await prefs.setInt(
      AppStorageNames.kRememberUntil,
      until.millisecondsSinceEpoch,
    );
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
    await prefs.setString(AppStorageNames.kTenantId, tenantId);
    await prefs.setInt(
      AppStorageNames.kTenantLicense,
      licenseUntil.millisecondsSinceEpoch,
    );
    await prefs.setString(AppStorageNames.kTenantName, name);
    await prefs.setString(AppStorageNames.kTenantDocument, document);
    await prefs.setBool(AppStorageNames.kTenantActive, active);
    await prefs.setInt(
      AppStorageNames.kTenantCreatedAt,
      createdAt.millisecondsSinceEpoch,
    );
    await prefs.setInt(
      AppStorageNames.kTenantUpdatedAt,
      updatedAt.millisecondsSinceEpoch,
    );
  }

  Future<AuthSession?> _restoreAuthSessionFromCache() async {
    final prefs = await SharedPreferences.getInstance();

    final tenantId = prefs.getString(AppStorageNames.kTenantId);
    final name = prefs.getString(AppStorageNames.kTenantName);
    final document = prefs.getString(AppStorageNames.kTenantDocument);
    final active = prefs.getBool(AppStorageNames.kTenantActive);
    final createdAtMs = prefs.getInt(AppStorageNames.kTenantCreatedAt);
    final updatedAtMs = prefs.getInt(AppStorageNames.kTenantUpdatedAt);
    final licMs = prefs.getInt(AppStorageNames.kTenantLicense);
    final roleStr = await AppSecureStorageService.getString(AppStorageNames.kUserRole) ?? 'USER';
    final userRole = UserRole.fromString(roleStr);

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

    return AuthSession(
      user: _auth.currentUser!,
      tenant: tenantSession,
      userRole: userRole,
    );
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
      throw FirebaseAuthException(code: 'unknow-email');
    }

    final userDocSnap = usersSnap.docs.first; // tenants/{tenantId}/users/{uid}

    final tenantRef = userDocSnap.reference.parent.parent!;
    final tenantId = tenantRef.id;

    final tenantDoc = await _firestore
        .collection('tenants')
        .doc(tenantId)
        .get();

    if (!tenantDoc.exists) {
      throw FirebaseAuthException(code: 'tenant-not-found');
    }

    final t = tenantDoc.data()!;
    final name = (t['name'] ?? '-') as String;
    final document = (t['document'] ?? '-') as String;
    final createdAt = (t['createdAt'] as Timestamp).toDate();
    final updatedAt = (t['updatedAt'] as Timestamp).toDate();

    final active = (t['active'] ?? false) as bool;
    if (!active) throw FirebaseAuthException(code: 'tenant-inactive');

    final licenseTs = t['licenseUntil'];
    if (licenseTs == null) {
      throw FirebaseAuthException(code: 'license-not-found');
    }

    final licenseUntil = (licenseTs as Timestamp).toDate();
    if (licenseUntil.isBefore(DateTime.now())) {
      throw FirebaseAuthException(code: 'license-expired');
    }

    final userData = userDocSnap.data();
    final roleStr = (userData['role'] ?? 'USER') as String;
    final role = UserRole.fromString(roleStr);
    await AppSecureStorageService.setString(AppStorageNames.kUserRole, role.asString);

    await _persistTenantCache(
      tenantId: tenantId,
      licenseUntil: licenseUntil,
      name: name,
      document: document,
      active: active,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );

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
