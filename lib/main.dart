import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:management/core/router/app_router.dart';
import 'package:management/core/services/app_auth_service.dart';
import 'package:management/core/services/app_database_service.dart';
import 'package:management/core/themes/theme_notifier.dart';
import 'package:management/firebase_options.dart';
import 'package:management/modules/auth/controllers/auth_controller.dart';
import 'package:management/shared/providers/global/global_providers.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final dbService = AppDatabaseService();
  final authService = AppAuthService();
  await dbService.init();

  runApp(
    MultiProvider(
      providers: GlobalProviders.all(dbService),
      child: ManagementApp(authService: authService),
    ),
  );
}

class ManagementApp extends StatelessWidget {
  const ManagementApp({super.key, required this.authService});

  final AppAuthService authService;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final themeNotifier = context.watch<ThemeNotifier>();
        final auth = context.watch<AuthController>();
        final appRouter = AppRouter(auth).router;

        return MaterialApp.router(
          title: 'NexGestor',
          debugShowCheckedModeBanner: false,
          theme: themeNotifier.currentTheme,
          routerConfig: appRouter,
        );
      },
    );
  }
}
