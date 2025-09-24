import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:management/core/extensions/auth_extensions.dart';
import 'package:management/core/extensions/theme_extensions.dart';
import 'package:management/core/router/app_router.dart';
import 'package:management/core/services/app_database_service.dart';
import 'package:management/firebase_options.dart';
import 'package:management/shared/providers/global/global_providers.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);

  final db = AppDatabaseService();
  await db.init();

  runApp(App(db));
}

class App extends StatelessWidget {
  const App(this.db, {super.key});
  final AppDatabaseService db;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: GlobalProviders.all(db),
      child: Builder(
        builder: (ctx) => MaterialApp.router(
          title: 'NexGestor',
          debugShowCheckedModeBanner: false,
          theme: ctx.theme.currentTheme,
          routerConfig: AppRouter(ctx.auth).router,
        ),
      ),
    );
  }
}
