import 'package:flutter/material.dart';

class AppDrawerController extends StatefulWidget {
  final Widget child;

  const AppDrawerController({super.key, required this.child});

  static AppDrawerControllerState of(BuildContext context) {
    final state = context.findAncestorStateOfType<AppDrawerControllerState>();

    if (state == null) {
      throw Exception('AppDrawerController not found in context');
    }

    return state;
  }

  @override
  State<AppDrawerController> createState() => AppDrawerControllerState();
}

class AppDrawerControllerState extends State<AppDrawerController> {
  final ValueNotifier<bool> _isDrawerOpen = ValueNotifier(false);

  void setDrawerOpen(bool open) {
    _isDrawerOpen.value = open;
  }

  void toggleDrawer(BuildContext context) {
    if (_isDrawerOpen.value) {
      Navigator.of(context).maybePop();
    } else {
      Scaffold.of(context).openEndDrawer();
    }
  }

  ValueNotifier<bool> get drawerNotifier => _isDrawerOpen;

  @override
  Widget build(BuildContext context) {
    return _DrawerScope(drawerState: this, child: widget.child);
  }
}

class _DrawerScope extends InheritedWidget {
  final AppDrawerControllerState drawerState;

  const _DrawerScope({required this.drawerState, required super.child});

  @override
  bool updateShouldNotify(covariant _DrawerScope oldWidget) =>
      drawerState != oldWidget.drawerState;
}
