import 'package:management/core/services/app_database_service.dart';
import 'package:management/modules/customer/repositories/customer_repository.dart';
import 'package:provider/provider.dart';

class RepositoryProviders {
  static List all = [
    Provider(create: (c) => CustomerRepository(c.read<AppDatabaseService>())),
  ];
}
