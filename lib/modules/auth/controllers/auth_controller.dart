import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:management/core/services/app_auth_service.dart';
import 'package:management/modules/auth/enums/auth_role_enum.dart';
import 'package:management/modules/auth/models/auth_session.dart';

class AuthController extends ChangeNotifier {
  AuthController(this._service);

  final AppAuthService _service;

  StreamSubscription<User?>? _sub;

  User? _user;
  AuthSession? _session;
  bool _sessionValid = false;

  User? get user => _user;
  AuthSession? get session => _session;
  bool get isLoggedIn => _user != null && _sessionValid;

  String? get tenantId => _session?.tenant.tenantId;
  String? get tenantName => _session?.tenant.name;
  DateTime? get licenseUntil => _session?.tenant.licenseUntil;

  bool get isMaster => _session?.userRole == UserRole.master;
  bool get isUser => _session?.userRole == UserRole.user;
  bool get isManager =>
      _session?.userRole == UserRole.master ||
      _session?.userRole == UserRole.manager;

  Future<void> init() async {
    await _service.init();

    _user = _service.currentUser;
    _session = _service.authSession;
    _sessionValid = await _service.isSessionValid;

    _sub = _service.onAuthStateChanged.listen((u) async {
      _user = u;
      _sessionValid = await _service.isSessionValid;
      _session = _service.authSession;
      notifyListeners();
    });

    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    final authSession = await _service.signIn(email: email, password: password);
    _user = _service.currentUser;
    _session = authSession;
    _sessionValid = await _service.isSessionValid;
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    final authSession = await _service.signInWithGoogle();
    _user = _service.currentUser;
    _session = authSession;
    _sessionValid = await _service.isSessionValid;
    notifyListeners();
  }

  Future<void> resetPassword(String email) async {
    await _service.resetPassword(email: email);
  }

  Future<void> signOut() async {
    await _service.signOut();
    _user = null;
    _session = null;
    _sessionValid = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
