import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:management/core/constants/app_route_names.dart';
import 'package:management/modules/customer/models/customer_model.dart';
import 'package:management/modules/customer/pages/customer_detail_page.dart';
import 'package:management/modules/customer/pages/customer_form_page.dart';
import 'package:management/modules/customer/pages/customer_list_page.dart';
import 'package:management/modules/dashboard/pages/dashboard_page.dart';
import 'package:management/modules/product/models/product_model.dart';
import 'package:management/modules/product/pages/product_form_page.dart';
import 'package:management/modules/product/pages/product_list_page.dart';

class AppRouter {
  static final routerObserver = RouteObserver<PageRoute>();

  static final GoRouter router = GoRouter(
    initialLocation: AppRouteNames.dashboard,
    observers: [routerObserver],
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
      GoRoute(
        path: AppRouteNames.customerDetail,
        name: AppRouteNames.customerDetail,
        builder: (context, state) {
          final extra = state.extra as CustomerModel;
          return CustomerDetailPage(customer: extra);
        },
      ),
      GoRoute(
        path: AppRouteNames.products,
        name: AppRouteNames.products,
        builder: (context, state) => const ProductListPage(),
      ),
      GoRoute(
        path: AppRouteNames.productForm,
        name: AppRouteNames.productForm,
        builder: (context, state) {
          final extra = state.extra as ProductModel?;
          return ProductFormPage(product: extra);
        },
      ),
      GoRoute(
        path: AppRouteNames.productDetail,
        name: AppRouteNames.productDetail,
        builder: (context, state) {
          // final extra = state.extra as ProductModel;
          return Container();
        },
      ),
    ],
  );
}
