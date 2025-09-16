import 'dart:async';

import 'package:management/core/services/app_auth_service.dart';
import 'package:management/core/services/app_database_service.dart';
import 'package:management/core/themes/theme_notifier.dart';
import 'package:management/modules/auth/controllers/auth_controller.dart';
import 'package:management/modules/customer/repositories/customer_repository.dart';
import 'package:management/modules/product/repositories/product_repository.dart';
import 'package:management/modules/sale/repositories/sale_repository.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class GlobalProviders {
  static List<SingleChildWidget> all(AppDatabaseService dbService) => [
    Provider<AppDatabaseService>.value(value: dbService),
    Provider<AppAuthService>(create: (_) => AppAuthService()),
    ChangeNotifierProvider(create: (_) => ThemeNotifier()),
    ChangeNotifierProvider<AuthController>(
      create: (c) {
        final ctrl = AuthController(c.read<AppAuthService>());
        unawaited(ctrl.init());
        return ctrl;
      },
    ),
    ...repositories,
  ];

  static List<SingleChildWidget> repositories = [
    Provider(create: (c) => CustomerRepository(c.read())),
    Provider(create: (c) => ProductRepository(c.read())),
    Provider(create: (c) => SaleRepository(c.read())),
  ];
}
