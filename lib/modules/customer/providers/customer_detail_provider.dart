import 'package:management/core/models/base_detail_provider.dart';
import 'package:management/modules/customer/models/customer_model.dart';
import 'package:management/modules/customer/repositories/customer_repository.dart';

class CustomerDetailProvider
    extends BaseDetailProvider<CustomerModel, CustomerRepository> {
  CustomerDetailProvider(super.repository);
}
