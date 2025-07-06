import 'package:flutter/material.dart';
import 'package:management/core/components/app_drawer.dart';
import 'package:management/core/components/app_drawer_controller.dart';
import 'package:management/core/components/app_drawer_toggle_button.dart';
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
    final drawerState = AppDrawerController.of(context);

    return Scaffold(
      appBar: AppNavBar(
        title: title,
        showBack: showBack,
        onBack: onBack,
        leading: const AppThemeToggleButton(),
        actions: withDrawer
            ? [AppDrawerToggleButton(drawerState: drawerState)]
            : null,
      ),
      endDrawerEnableOpenDragGesture: true,
      onEndDrawerChanged: drawerState.setDrawerOpen,
      endDrawer: withDrawer ? const AppDrawer() : null,
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
