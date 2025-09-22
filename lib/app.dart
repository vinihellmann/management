import 'package:flutter/material.dart';
import 'package:management/core/extensions/extensions.dart';
import 'package:management/core/models/app_dependencies.dart';
import 'package:management/core/router/app_router.dart';
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
    return MaterialApp.router(
      title: 'NexGestor',
      debugShowCheckedModeBanner: false,
      theme: context.theme.currentTheme,
      routerConfig: AppRouter(context.auth).router,
    );
  }
}
