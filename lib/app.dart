import 'package:flutter/material.dart';
import 'package:management/core/models/app_dependencies.dart';
import 'package:management/core/router/app_router.dart';
import 'package:management/core/themes/theme_notifier.dart';
import 'package:management/modules/auth/controllers/auth_controller.dart';
import 'package:management/shared/providers/global/global_providers.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key, required this.deps});

  final AppDependencies deps;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: GlobalProviders.all(deps),
      child: const _ManagementApp(),
    );
  }
}

class _ManagementApp extends StatelessWidget {
  const _ManagementApp();

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeNotifier>();
    final auth = context.watch<AuthController>();
    final appRouter = AppRouter(auth).router;

    return MaterialApp.router(
      title: 'NexGestor',
      debugShowCheckedModeBanner: false,
      theme: themeNotifier.currentTheme,
      routerConfig: appRouter,
    );
  }
}
