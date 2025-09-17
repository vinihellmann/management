import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:management/app.dart';
import 'package:management/core/models/app_dependencies.dart';
import 'package:management/core/services/app_auth_service.dart';
import 'package:management/core/services/app_database_service.dart';
import 'package:management/core/services/app_env_service.dart';
import 'package:management/firebase_options.dart';

class Bootstrap {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    await AppEnvService.init();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final db = AppDatabaseService();
    await db.init();

    final auth = AppAuthService();

    runApp(
      App(
        deps: AppDependencies(db: db, auth: auth),
      ),
    );
  }
}
