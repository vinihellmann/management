import 'package:management/core/constants/app_table_names.dart';
import 'package:management/core/models/app_exception.dart';
import 'package:management/core/models/base_repository.dart';
import 'package:management/core/models/paginated_result.dart';
import 'package:management/core/services/app_database_service.dart';
import 'package:management/modules/product/models/product_model.dart';
import 'package:management/modules/product/models/product_unit_model.dart';
import 'package:sqflite/sqflite.dart';

class ProductRepository extends BaseRepository<ProductModel> {
  ProductRepository(AppDatabaseService db) : super(db, AppTableNames.products);

  @override
  ProductModel fromMap(Map<String, dynamic> map) {
    return ProductModel().fromMap(map);
  }

  ProductUnitModel fromMapUnit(Map<String, dynamic> map) {
    return ProductUnitModel().fromMap(map);
  }

  @override
  Future<PaginatedResult<ProductModel>> getAll({
    int page = 1,
    int pageSize = 10,
    Map<String, dynamic>? filters,
    required String orderBy,
  }) async {
    try {
      final offset = (page - 1) * pageSize;

      final where = buildWhere(filters);
      final whereArgs = buildWhereArgs(filters);

      final result = await db.query(
        tableName,
        where: where,
        whereArgs: whereArgs,
        orderBy: orderBy,
        limit: pageSize,
        offset: offset,
      );

      final countResult = await db.rawQuery(
        'SELECT COUNT(*) as total FROM $tableName ${where != null ? 'WHERE $where' : ''}',
        whereArgs,
      );

      final products = result.map((map) => fromMap(map)).toList();

      for (final product in products) {
        product.units = await getUnitsByProductId(product.id!);
      }

      final total = Sqflite.firstIntValue(countResult) ?? 0;

      return PaginatedResult(items: products, total: total);
    } catch (e, stack) {
      throw AppException(
        'Erro ao buscar os produtos com unidades',
        detail: e.toString(),
        stackTrace: stack,
      );
    }
  }

  Future<List<ProductUnitModel>> getUnitsByProductId(int productId) async {
    try {
      final result = await db.rawQuery(
        'SELECT * FROM ${AppTableNames.productUnits} WHERE productId = ? ORDER BY isDefault DESC, id ASC',
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
