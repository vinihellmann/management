import 'package:flutter/material.dart';
import 'package:management/modules/customer/repositories/customer_repository.dart';

class DashboardProvider extends ChangeNotifier {
  final CustomerRepository customerRepository;

  DashboardProvider(this.customerRepository);

  int totalCustomers = 0;

  bool isLoading = false;

  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();

    totalCustomers = await customerRepository.count();

    isLoading = false;
    notifyListeners();
  }
}
