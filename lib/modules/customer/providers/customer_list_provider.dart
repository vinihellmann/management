import 'package:management/core/models/base_list_provider.dart';
import 'package:management/modules/customer/models/customer_filters.dart';
import 'package:management/modules/customer/models/customer_model.dart';
import 'package:management/modules/customer/repositories/customer_repository.dart';

class CustomerListProvider
    extends
        BaseListProvider<CustomerModel, CustomerRepository, CustomerFilters> {
  CustomerListProvider(repository) : super(repository, CustomerFilters());
}
