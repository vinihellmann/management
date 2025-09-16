import 'package:flutter/material.dart';
import 'package:management/core/components/app_drawer.dart';
import 'package:management/core/components/app_nav_bar.dart';
import 'package:management/core/components/app_theme_toggle_button.dart';

class AppLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton;
  final bool showBack;
  final VoidCallback? onBack;
  final bool withDrawer;

  const AppLayout({
    super.key,
    required this.title,
    required this.body,
    this.floatingActionButton,
    this.showBack = true,
    this.onBack,
    this.withDrawer = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavBar(
        title: title,
        showBack: showBack,
        onBack: onBack,
        leading: const AppThemeToggleButton(),
        withDrawer: withDrawer,
      ),
      endDrawerEnableOpenDragGesture: true,
      endDrawer: withDrawer ? const AppDrawer() : null,
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
