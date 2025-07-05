import 'package:flutter/material.dart';
import 'package:management/core/components/app_drawer_controller.dart';

class AppDrawerToggleButton extends StatelessWidget {
  final AppDrawerControllerState drawerState;

  const AppDrawerToggleButton({super.key, required this.drawerState});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ValueListenableBuilder<bool>(
        valueListenable: drawerState.drawerNotifier,
        builder: (_, isOpen, __) {
          return AnimatedRotation(
            turns: isOpen ? 0.5 : 0,
            duration: const Duration(milliseconds: 300),
            child: IconButton(
              icon: Icon(isOpen ? Icons.close : Icons.menu_open_rounded),
              tooltip: isOpen ? 'Fechar menu' : 'Abrir menu',
              onPressed: () => drawerState.toggleDrawer(context),
            ),
          );
        },
      ),
    );
  }
}
