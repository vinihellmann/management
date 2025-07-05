import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:management/core/constants/app_route_names.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.toString();

    return SafeArea(
      child: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 8,
            children: [
              _DrawerItem(
                'Dashboard',
                Icons.dashboard,
                AppRouteNames.dashboard,
                currentRoute,
              ),
              _DrawerItem(
                'Clientes',
                Icons.people,
                AppRouteNames.customers,
                currentRoute,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final String route;
  final String current;

  const _DrawerItem(this.label, this.icon, this.route, this.current);

  @override
  Widget build(BuildContext context) {
    final selected = current == route;
    final theme = Theme.of(context);

    return ListTile(
      style: ListTileStyle.drawer,
      selected: selected,
      selectedTileColor: theme.colorScheme.primary.withAlpha(25),
      leading: Icon(icon, color: selected ? theme.colorScheme.primary : null),
      title: Text(
        label,
        style: TextStyle(
          color: selected ? theme.colorScheme.primary : null,
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      onTap: () {
        Navigator.of(context).pop();
        context.pushNamed(route);
      },
    );
  }
}
