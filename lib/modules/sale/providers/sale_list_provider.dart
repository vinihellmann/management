import 'package:management/core/models/base_list_provider.dart';
import 'package:management/modules/sale/models/sale_filters.dart';
import 'package:management/modules/sale/models/sale_model.dart';
import 'package:management/modules/sale/repositories/sale_repository.dart';

class SaleListProvider
    extends BaseListProvider<SaleModel, SaleRepository, SaleFilters> {
  SaleListProvider(repository) : super(repository, SaleFilters());
}
