import 'package:management/core/models/base_detail_provider.dart';
import 'package:management/modules/sale/models/sale_item_model.dart';
import 'package:management/modules/sale/models/sale_model.dart';
import 'package:management/modules/sale/repositories/sale_repository.dart';

class SaleDetailProvider extends BaseDetailProvider<SaleModel, SaleRepository> {
  SaleDetailProvider(super.repository);

  List<SaleItemModel> items = [];

  Future<void> loadItems(List<SaleItemModel> saleItems) async {
    items = saleItems;
    notifyListeners();
  }
}
