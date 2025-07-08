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
    final theme = Theme.of(context);

    return SafeArea(
      child: Drawer(
        backgroundColor: theme.scaffoldBackgroundColor,
        child: Column(
          children: [
            const SizedBox(height: 12),
            const _DrawerHeader(),
            const Divider(height: 24, thickness: 1, indent: 16, endIndent: 16),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _DrawerItem(
                    label: 'Dashboard',
                    icon: Icons.dashboard_outlined,
                    route: AppRouteNames.dashboard,
                    current: currentRoute,
                  ),
                  _DrawerItem(
                    label: 'Clientes',
                    icon: Icons.people_outline,
                    route: AppRouteNames.customers,
                    current: currentRoute,
                  ),
                  _DrawerItem(
                    label: 'Produtos',
                    icon: Icons.inventory_2_outlined,
                    route: AppRouteNames.products,
                    current: currentRoute,
                  ),
                  _DrawerItem(
                    label: 'Vendas',
                    icon: Icons.shopping_bag_outlined,
                    route: AppRouteNames.sales,
                    current: currentRoute,
                  ),
                ],
              ),
            ),
          ],
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.lightBackground,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Image.asset(AppAssetNames.logoPath),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NexGestor',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Versão $version',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
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

  const _DrawerItem({
    required this.label,
    required this.icon,
    required this.route,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selected = current == route;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: selected ? theme.colorScheme.primary.withAlpha(50) : null,
        child: ListTile(
          selected: selected,
          selectedTileColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          leading: Icon(
            icon,
            color: selected ? theme.colorScheme.primary : theme.iconTheme.color,
          ),
          title: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              color: selected ? theme.colorScheme.primary : null,
            ),
          ),
          onTap: () {
            Navigator.of(context).pop();
            context.pushNamed(route);
          },
        ),
      ),
    );
  }
}
