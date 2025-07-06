import 'package:flutter/material.dart';
import 'package:management/core/components/app_drawer_controller.dart';
import 'package:management/core/router/app_router.dart';
import 'package:management/core/services/app_database_service.dart';
import 'package:management/core/themes/theme_notifier.dart';
import 'package:management/modules/dashboard/providers/dashboard_provider.dart';
import 'package:management/shared/providers/repository_providers.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbService = AppDatabaseService();
  await dbService.init();

  runApp(
    AppDrawerController(
      child: MultiProvider(
        providers: [
          Provider<AppDatabaseService>.value(value: dbService),
          ...RepositoryProviders.all,
          ChangeNotifierProvider(create: (_) => ThemeNotifier()),
          ChangeNotifierProvider(
            create: (ctx) => DashboardProvider(ctx.read())..loadData(),
          ),
        ],
        child: const ManagementApp(),
      ),
    ),
  );
}

class ManagementApp extends StatelessWidget {
  const ManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp.router(
      title: 'NexGestor',
      debugShowCheckedModeBanner: false,
      theme: themeNotifier.currentTheme,
      routerConfig: AppRouter.router,
    );
  }
}
