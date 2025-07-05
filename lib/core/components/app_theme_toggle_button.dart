import 'package:flutter/material.dart';
import 'package:management/core/themes/theme_notifier.dart';
import 'package:provider/provider.dart';

class AppThemeToggleButton extends StatelessWidget {
  const AppThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeNotifier>();
    final isDark = themeNotifier.isDarkMode;

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: IconButton(
        tooltip: isDark ? 'Modo claro' : 'Modo escuro',
        icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
        onPressed: themeNotifier.toggleTheme,
      ),
    );
  }
}
