import 'package:management/core/services/app_auth_service.dart';
import 'package:management/core/services/app_database_service.dart';

class AppDependencies {
  final AppDatabaseService db;
  final AppAuthService auth;

  AppDependencies({required this.db, required this.auth});
}
