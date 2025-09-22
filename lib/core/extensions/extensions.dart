import 'package:flutter/widgets.dart';
import 'package:management/core/themes/theme_notifier.dart';
import 'package:management/modules/auth/controllers/auth_controller.dart';
import 'package:provider/provider.dart';

extension AuthContextX on BuildContext {
  AuthController get auth => watch<AuthController>();

  bool get isMaster => auth.isMaster;
  bool get isManager => auth.isManager;
  bool get isUser => auth.isUser;
}

extension ThemeNotifierContextX on BuildContext {
  ThemeNotifier get theme => watch<ThemeNotifier>();

  bool get isLight => !theme.isDarkMode;
  bool get isDark => theme.isDarkMode;
}
