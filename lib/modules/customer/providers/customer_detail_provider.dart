import 'package:flutter/material.dart';
import 'package:management/modules/customer/models/customer_model.dart';
import 'package:management/modules/customer/repositories/customer_repository.dart';

class CustomerDetailProvider extends ChangeNotifier {
  final CustomerRepository repository;
  final CustomerModel customer;

  CustomerDetailProvider(this.repository, this.customer);

  Future<void> deleteCustomer() async {
    if (customer.id != null) {
      await repository.delete(customer.id!);
    }
  }
}
