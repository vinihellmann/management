import 'package:management/core/services/app_database_service.dart';
import 'package:management/core/themes/theme_notifier.dart';
import 'package:management/modules/auth/controllers/auth_controller.dart';
import 'package:management/modules/customer/repositories/customer_repository.dart';
import 'package:management/modules/product/repositories/product_repository.dart';
import 'package:management/modules/sale/repositories/sale_repository.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class GlobalProviders {
  static List<SingleChildWidget> all(AppDatabaseService db) => [
    ChangeNotifierProvider<AuthController>(
      create: (_) => AuthController()..init(),
    ),
    Provider<AppDatabaseService>.value(value: db),
    ChangeNotifierProvider<ThemeNotifier>(create: (_) => ThemeNotifier()),
    ...repositories,
  ];

  static List<SingleChildWidget> repositories = [
    Provider(create: (c) => CustomerRepository(c.read<AppDatabaseService>())),
    Provider(create: (c) => ProductRepository(c.read<AppDatabaseService>())),
    Provider(create: (c) => SaleRepository(c.read<AppDatabaseService>())),
  ];
}
