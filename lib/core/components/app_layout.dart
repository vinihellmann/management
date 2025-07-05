import 'package:flutter/material.dart';
import 'package:management/core/components/app_drawer.dart';
import 'package:management/core/components/app_drawer_controller.dart';
import 'package:management/core/components/app_drawer_toggle_button.dart';
import 'package:management/core/components/app_loading_overlay.dart';
import 'package:management/core/components/app_nav_bar.dart';
import 'package:management/core/components/app_theme_toggle_button.dart';

class AppLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton;
  final bool showBack;
  final VoidCallback? onBack;
  final double? padding;
  final bool isLoading;

  const AppLayout({
    super.key,
    required this.title,
    required this.body,
    this.floatingActionButton,
    this.showBack = true,
    this.onBack,
    this.padding,
    this.isLoading = false,
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
        actions: [AppDrawerToggleButton(drawerState: drawerState)],
      ),
      endDrawerEnableOpenDragGesture: true,
      onEndDrawerChanged: drawerState.setDrawerOpen,
      endDrawer: const AppDrawer(),
      body: Stack(
        children: [
          Padding(padding: EdgeInsets.all(padding ?? 16), child: body),
          AppLoadingOverlay(visible: isLoading),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
