import 'package:management/core/models/base_detail_provider.dart';
import 'package:management/modules/product/models/product_model.dart';
import 'package:management/modules/product/models/product_unit_model.dart';
import 'package:management/modules/product/repositories/product_repository.dart';

class ProductDetailProvider
    extends BaseDetailProvider<ProductModel, ProductRepository> {
  ProductDetailProvider(super.repository);

  List<ProductUnitModel> units = [];

  Future<void> loadUnits(int productId) async {
    units = await repository.getUnitsByProductId(productId);
    notifyListeners();
  }
}
