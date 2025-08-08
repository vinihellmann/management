import 'package:flutter/material.dart';
import 'package:management/modules/customer/repositories/customer_repository.dart';
import 'package:management/modules/sale/models/sale_model.dart';
import 'package:management/modules/sale/repositories/sale_repository.dart';

class DashboardProvider extends ChangeNotifier {
  final CustomerRepository customerRepository;
  final SaleRepository saleRepository;

  DashboardProvider(this.customerRepository, this.saleRepository);

  int totalCustomers = 0;
  int salesOpenCount = 0;
  double salesThisMonth = 0.0;
  double salesToReceive = 0.0;
  Map<String, double> salesByStatusMap = {};

  bool isLoading = false;

  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();

    totalCustomers = await customerRepository.count();

    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    salesThisMonth = await saleRepository.sumByStatusAndDateRange(
      SaleStatusEnum.completed,
      firstDayOfMonth,
      lastDayOfMonth,
    );

    salesOpenCount = await saleRepository.countByStatus(SaleStatusEnum.open);

    salesToReceive = await saleRepository.sumByStatuses([
      SaleStatusEnum.open,
      SaleStatusEnum.awaitingPayment,
      SaleStatusEnum.confirmed,
      SaleStatusEnum.sent,
    ]);

    salesByStatusMap = await saleRepository.getSumByStatus();

    isLoading = false;
    notifyListeners();
  }
}
