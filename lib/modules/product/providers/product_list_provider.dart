import 'package:management/core/models/base_list_provider.dart';
import 'package:management/modules/product/models/product_filters.dart';
import 'package:management/modules/product/models/product_model.dart';
import 'package:management/modules/product/repositories/product_repository.dart';

class ProductListProvider
    extends BaseListProvider<ProductModel, ProductRepository, ProductFilters> {
  ProductListProvider(repository) : super(repository, ProductFilters());
}
