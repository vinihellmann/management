import 'package:management/core/constants/app_table_names.dart';
import 'package:management/core/models/app_exception.dart';
import 'package:management/core/models/base_repository.dart';
import 'package:management/core/services/app_database_service.dart';
import 'package:management/modules/product/models/product_model.dart';
import 'package:management/modules/product/models/product_unit_model.dart';

class ProductRepository extends BaseRepository<ProductModel> {
  ProductRepository(AppDatabaseService db) : super(db, AppTableNames.products);

  @override
  ProductModel fromMap(Map<String, dynamic> map) {
    return ProductModel().fromMap(map);
  }

  ProductUnitModel fromMapUnit(Map<String, dynamic> map) {
    return ProductUnitModel().fromMap(map);
  }

  Future<List<ProductUnitModel>> getUnitsByProductId(int productId) async {
    try {
      final result = await db.rawQuery(
        'SELECT * FROM ${AppTableNames.productUnits} WHERE productId = ? ORDER BY name',
        [productId],
      );
      return result.map(fromMapUnit).toList();
    } catch (e, stack) {
      throw AppException(
        'Erro ao buscar unidades do produto',
        detail: e.toString(),
        stackTrace: stack,
      );
    }
  }

  Future<void> insertUnits(int productId, List<ProductUnitModel> units) async {
    try {
      for (final unit in units) {
        unit.productId = productId;
        final data = unit.toMap();
        await db.insert(AppTableNames.productUnits, data);
      }
    } catch (e, stack) {
      throw AppException(
        'Erro ao inserir unidades',
        detail: e.toString(),
        stackTrace: stack,
      );
    }
  }

  Future<void> deleteUnitsByProductId(int productId) async {
    try {
      await db.delete(AppTableNames.productUnits, productId, 'productId');
    } catch (e, stack) {
      throw AppException(
        'Erro ao deletar unidades do produto',
        detail: e.toString(),
        stackTrace: stack,
      );
    }
  }

  Future<void> replaceUnits(int productId, List<ProductUnitModel> units) async {
    await deleteUnitsByProductId(productId);
    await insertUnits(productId, units);
  }
}
