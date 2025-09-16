import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:management/core/services/app_toast_service.dart';
import 'package:management/modules/auth/controllers/auth_controller.dart';

class LoginController extends ChangeNotifier {
  LoginController(this._authController);

  final AuthController _authController;

  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  bool _disposed = false;

  void toggleObscurePassword() {
    if (_disposed) return;
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  User? get user => _authController.user;

  Future<void> signIn() async {
    final form = formKey.currentState;

    if (form == null || !form.validate()) {
      AppToastService.showError('Preencha e corriga os campos para continuar.');
      return;
    }

    _setIsLoading(true);
    try {
      await _authController.signIn(email.text.trim(), password.text.trim());
    } on FirebaseAuthException catch (e) {
      AppToastService.showError(mapFirebaseError(e));
    } catch (_) {
      AppToastService.showError('Falha inesperada. Tente novamente.');
    } finally {
      _setIsLoading(false);
    }
  }

  Future<void> resetPassword() async {
    _setIsLoading(true);
    try {
      await _authController.resetPassword(email.text.trim());
      AppToastService.showSuccess(
        'Enviamos um e-mail para redefinir sua senha.',
      );
    } on FirebaseAuthException catch (e) {
      AppToastService.showError(mapFirebaseError(e));
    } finally {
      _setIsLoading(false);
    }
  }

  Future<void> signOut() async {
    _setIsLoading(true);
    try {
      await _authController.signOut();
    } finally {
      _setIsLoading(false);
    }
  }

  void _setIsLoading(bool value) {
    if (_disposed) return;
    if (_isLoading == value) return;
    _isLoading = value;
    notifyListeners();
  }

  String mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
      case 'invalid-credential':
      case 'wrong-password':
        return 'E-mail ou senha inválidos.';
      case 'invalid-email':
        return 'E-mail inválido.';
      case 'user-disabled':
        return 'Usuário desativado.';
      case 'too-many-requests':
        return 'Muitas tentativas. Aguarde um pouco e tente novamente.';
      default:
        return 'Erro de autenticação (${e.code}).';
    }
  }

  @override
  void dispose() {
    _disposed = true;
    email.dispose();
    password.dispose();
    super.dispose();
  }
}
