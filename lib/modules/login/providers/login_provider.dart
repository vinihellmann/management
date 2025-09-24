import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:management/core/services/app_toast_service.dart';
import 'package:management/modules/auth/controllers/auth_controller.dart';

class LoginController extends ChangeNotifier {
  LoginController(this._authController);

  final AuthController _authController;

  final formKey = GlobalKey<FormState>();

  final cgc = TextEditingController();
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

  User? get user => _authController.session?.firebaseUser;

  Future<void> signIn() async {
    final form = formKey.currentState;

    if (form == null || !form.validate()) {
      AppToastService.showError('Preencha os campos para continuar.');
      return;
    }

    _setIsLoading(true);
    try {
      final err = await _authController.signIn(
        cgc.text.trim(),
        email.text.trim(),
        password.text.trim(),
      );

      if (err != null) {
        AppToastService.showError(err);
        return;
      }
    } catch (_) {
      AppToastService.showError('Falha inesperada. Tente novamente.');
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
      case 'user-not-found-in-tenant':
        return 'Usuário não encontrado na empresa informada.';
      case 'license-expired':
        return 'Licença da empresa expirada.';
      case 'license-not-found':
        return 'Licença não encontrada para a empresa.';
      case 'tenant-not-found':
        return 'Empresa não encontrada.';
      case 'tenant-inactive':
        return 'Empresa inativada.';
      case 'unknow-email':
        return 'E-mail não vinculado a nenhuma empresa ativa.';
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
