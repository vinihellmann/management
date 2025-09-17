import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:management/core/services/app_auth_service.dart';

class AuthController extends ChangeNotifier {
  AuthController(this._service);

  final AppAuthService _service;

  StreamSubscription<User?>? _sub;
  Timer? _sessionWatchdog;

  User? _user;
  bool _sessionValid = false;

  User? get user => _user;
  bool get isLoggedIn => _user != null && _sessionValid;

  Future<void> init() async {
    _user = _service.currentUser;
    _sessionValid = await _service.isSessionValid;

    _sub = _service.onAuthStateChanged.listen((u) async {
      _user = u;
      _sessionValid = await _service.isSessionValid;
      notifyListeners();
    });

    _sessionWatchdog?.cancel();
    _sessionWatchdog = Timer.periodic(const Duration(seconds: 30), (_) async {
      if (_service.currentUser != null) {
        await _service.ensureSessionValidity();
      }
      
      final newValid = await _service.isSessionValid;
      if (newValid != _sessionValid || _service.currentUser != _user) {
        _user = _service.currentUser;
        _sessionValid = newValid;
        notifyListeners();
      }
    });

    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    await _service.signIn(email: email, password: password);
    _user = _service.currentUser;
    _sessionValid = await _service.isSessionValid;
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    await _service.signInWithGoogle();
    _user = _service.currentUser;
    _sessionValid = await _service.isSessionValid;
    notifyListeners();
  }

  Future<void> resetPassword(String email) async {
    await _service.resetPassword(email: email);
  }

  Future<void> signOut() async {
    await _service.signOut();
    _user = null;
    _sessionValid = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    _sessionWatchdog?.cancel();
    super.dispose();
  }
}
