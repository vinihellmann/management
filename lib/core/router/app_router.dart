import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:management/core/constants/app_route_names.dart';
import 'package:management/modules/customer/models/customer_model.dart';
import 'package:management/modules/customer/pages/customer_detail_page.dart';
import 'package:management/modules/customer/pages/customer_form_page.dart';
import 'package:management/modules/customer/pages/customer_list_page.dart';
import 'package:management/modules/customer/pages/customer_select_page.dart';
import 'package:management/modules/dashboard/pages/dashboard_page.dart';
import 'package:management/modules/product/models/product_model.dart';
import 'package:management/modules/product/pages/product_detail_page.dart';
import 'package:management/modules/product/pages/product_form_page.dart';
import 'package:management/modules/product/pages/product_list_page.dart';
import 'package:management/modules/product/pages/product_select_page.dart';
import 'package:management/modules/sale/models/sale_item_model.dart';
import 'package:management/modules/sale/models/sale_model.dart';
import 'package:management/modules/sale/pages/sale_detail_page.dart';
import 'package:management/modules/sale/pages/sale_form_edit_item_page.dart';
import 'package:management/modules/sale/pages/sale_form_page.dart';
import 'package:management/modules/sale/pages/sale_list_page.dart';

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
        path: AppRouteNames.customerSelect,
        name: AppRouteNames.customerSelect,
        builder: (context, state) => const CustomerSelectPage(),
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
        path: AppRouteNames.productSelect,
        name: AppRouteNames.productSelect,
        builder: (context, state) => const ProductSelectPage(),
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
          final extra = state.extra as ProductModel;
          return ProductDetailPage(product: extra);
        },
      ),
      GoRoute(
        path: AppRouteNames.sales,
        name: AppRouteNames.sales,
        builder: (context, state) => const SaleListPage(),
      ),
      GoRoute(
        path: AppRouteNames.saleForm,
        name: AppRouteNames.saleForm,
        builder: (context, state) {
          final extra = state.extra as SaleModel?;
          return SaleFormPage(sale: extra);
        },
      ),
      GoRoute(
        path: AppRouteNames.saleDetail,
        name: AppRouteNames.saleDetail,
        builder: (context, state) {
          final extra = state.extra as SaleModel;
          return SaleDetailPage(sale: extra);
        },
      ),
      GoRoute(
        path: AppRouteNames.saleFormEditItem,
        name: AppRouteNames.saleFormEditItem,
        builder: (context, state) {
          final extra = state.extra;

          if (extra is ProductModel) {
            return SaleFormEditItemPage(product: extra);
          } else {
            return SaleFormEditItemPage(saleItem: extra as SaleItemModel);
          }
        },
      ),
    ],
  );
}
