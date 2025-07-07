import 'package:management/core/models/base_list_provider.dart';
import 'package:management/modules/product/models/product_filters.dart';
import 'package:management/modules/sale/models/sale_model.dart';
import 'package:management/modules/sale/repositories/sale_repository.dart';

class SaleListProvider
    extends BaseListProvider<SaleModel, SaleRepository, ProductFilters> {
  SaleListProvider(repository) : super(repository, ProductFilters());
}
