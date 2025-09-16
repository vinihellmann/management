import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppAuthService {
  AppAuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  static const _kLastLoginAt = 'auth.lastLoginAt';
  static const _kRememberUntil = 'auth.rememberUntil';
  static const _sessionDays = 7;

  final FirebaseAuth _auth;

  Stream<User?> get onAuthStateChanged => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<bool> get isSessionValid async {
    final prefs = await SharedPreferences.getInstance();
    final untilMillis = prefs.getInt(_kRememberUntil);

    if (untilMillis == null) return false;

    final until = DateTime.fromMillisecondsSinceEpoch(untilMillis);
    return DateTime.now().isBefore(until);
  }

  Future<void> ensureSessionValidity() async {
    if (_auth.currentUser == null) return;

    final valid = await isSessionValid;
    if (!valid) await signOut();
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final now = DateTime.now();
    final until = now.add(const Duration(days: _sessionDays));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kLastLoginAt, now.millisecondsSinceEpoch);
    await prefs.setInt(_kRememberUntil, until.millisecondsSinceEpoch);

    return cred;
  }

  Future<void> resetPassword({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kLastLoginAt);
    await prefs.remove(_kRememberUntil);

    await _auth.signOut();
  }
}
