import 'package:go_router/go_router.dart';
import 'package:management/core/constants/app_route_names.dart';
import 'package:management/modules/customer/models/customer_model.dart';
import 'package:management/modules/customer/pages/customer_form_page.dart';
import 'package:management/modules/customer/pages/customer_list_page.dart';
import 'package:management/modules/dashboard/pages/dashboard_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRouteNames.dashboard,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRouteNames.dashboard,
        name: AppRouteNames.dashboard,
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: AppRouteNames.customers,
        name: AppRouteNames.customers,
        builder: (context, state) => const CustomerListPage(),
      ),
      GoRoute(
        path: AppRouteNames.customerForm,
        name: AppRouteNames.customerForm,
        builder: (context, state) {
          final extra = state.extra as CustomerModel?;
          return CustomerFormPage(customer: extra);
        },
      ),
    ],
  );
}
