import 'package:flutter/widgets.dart';
import 'package:management/core/themes/theme_notifier.dart';
import 'package:provider/provider.dart';

extension ThemeNotifierContextX on BuildContext {
  ThemeNotifier get theme => watch<ThemeNotifier>();

  bool get isLight => !theme.isDarkMode;
  bool get isDark => theme.isDarkMode;
}
