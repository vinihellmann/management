import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:management/core/constants/app_asset_names.dart';
import 'package:management/core/constants/app_route_names.dart';
import 'package:management/core/themes/app_colors.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
              const _DrawerHeader(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Divider(height: 4),
              ),
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
              _DrawerItem(
                'Produtos',
                Icons.inventory_2,
                AppRouteNames.products,
                currentRoute,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        final version = snapshot.data?.version ?? '';

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.lightBackground,
                  child: Image.asset(AppAssetNames.logoPath),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  Text(
                    'NexGestor',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Versão: $version', style: theme.textTheme.bodySmall),
                ],
              ),
            ],
          ),
        );
      },
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
