import 'package:management/core/constants/app_table_names.dart';
import 'package:management/core/models/app_exception.dart';
import 'package:management/core/models/base_repository.dart';
import 'package:management/core/models/paginated_result.dart';
import 'package:management/core/services/app_database_service.dart';
import 'package:management/modules/customer/models/customer_model.dart';
import 'package:management/modules/product/models/product_model.dart';
import 'package:management/modules/product/models/product_unit_model.dart';
import 'package:management/modules/sale/models/sale_item_model.dart';
import 'package:management/modules/sale/models/sale_model.dart';
import 'package:management/modules/sale/models/sale_status_enum.dart';
import 'package:sqflite/sqflite.dart';

class SaleRepository extends BaseRepository<SaleModel> {
  SaleRepository(AppDatabaseService db) : super(db, AppTableNames.sales);

  @override
  SaleModel fromMap(Map<String, dynamic> map) {
    return SaleModel().fromMap(map);
  }

  SaleItemModel fromItemMap(Map<String, dynamic> map) {
    return SaleItemModel().fromMap(map);
  }

  CustomerModel fromCustomerMap(Map<String, dynamic> map) {
    return CustomerModel().fromMap(map);
  }

  ProductModel fromProductMap(Map<String, dynamic> map) {
    return ProductModel().fromMap(map);
  }

  ProductUnitModel fromUnitMap(Map<String, dynamic> map) {
    return ProductUnitModel().fromMap(map);
  }

  @override
  Future<PaginatedResult<SaleModel>> getAll({
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

      final sales = result.map((map) => fromMap(map)).toList();

      for (final sale in sales) {
        sale.items = await getItemsBySaleId(sale.id!);
      }

      final total = Sqflite.firstIntValue(countResult) ?? 0;

      return PaginatedResult(items: sales, total: total);
    } catch (e, stack) {
      throw AppException(
        'Erro ao buscar as vendas com produtos',
        detail: e.toString(),
        stackTrace: stack,
      );
    }
  }

  Future<List<SaleItemModel>> getItemsBySaleId(int saleId) async {
    try {
      final result = await db.rawQuery(
        'SELECT * FROM ${AppTableNames.saleItems} WHERE saleId = ? ORDER BY id ASC',
        [saleId],
      );
      return result.map(fromItemMap).toList();
    } catch (e, stack) {
      throw AppException(
        'Erro ao buscar itens da venda',
        detail: e.toString(),
        stackTrace: stack,
      );
    }
  }

  Future<CustomerModel> getSaleCustomerById(int customerId) async {
    try {
      final result = await db.rawQuery(
        'SELECT * FROM ${AppTableNames.customers} WHERE id = ? ORDER BY id ASC',
        [customerId],
      );
      return fromCustomerMap(result.first);
    } catch (e, stack) {
      throw AppException(
        'Erro ao buscar itens da venda',
        detail: e.toString(),
        stackTrace: stack,
      );
    }
  }

  Future<ProductModel> getProductById(int id) async {
    try {
      final resultProd = await db.rawQuery(
        'SELECT * FROM ${AppTableNames.products} WHERE id = ?',
        [id],
      );
      final product = fromProductMap(resultProd.first);

      final resultUnit = await db.rawQuery(
        'SELECT * FROM ${AppTableNames.productUnits} WHERE productId = ? ORDER BY isDefault DESC, id ASC',
        [id],
      );
      product.units = resultUnit.map((u) => fromUnitMap(u)).toList();
      return product;
    } catch (e, stack) {
      throw AppException(
        'Erro ao buscar itens da venda',
        detail: e.toString(),
        stackTrace: stack,
      );
    }
  }

  Future<void> insertItems(int saleId, List<SaleItemModel> items) async {
    try {
      for (final item in items) {
        item.saleId = saleId;
        final data = item.toMap();
        await db.insert(AppTableNames.saleItems, data);
      }
    } catch (e, stack) {
      throw AppException(
        'Erro ao inserir itens da venda',
        detail: e.toString(),
        stackTrace: stack,
      );
    }
  }

  Future<void> deleteItemsBySaleId(int saleId) async {
    try {
      await db.delete(AppTableNames.saleItems, saleId, 'saleId');
    } catch (e, stack) {
      throw AppException(
        'Erro ao deletar itens da venda',
        detail: e.toString(),
        stackTrace: stack,
      );
    }
  }

  Future<void> replaceItems(int saleId, List<SaleItemModel> items) async {
    await deleteItemsBySaleId(saleId);
    await insertItems(saleId, items);
  }

  Future<double> sumByStatusAndDateRange(
    SaleStatusEnum status,
    DateTime start,
    DateTime end,
  ) async {
    final result = await db.rawQuery(
      '''
        SELECT SUM(totalSale) as total
        FROM sales
        WHERE status = ?
          AND createdAt BETWEEN ? AND ?
      ''',
      [status.name, start.toIso8601String(), end.toIso8601String()],
    );

    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<int> countByStatus(SaleStatusEnum status) async {
    final result = await db.rawQuery(
      '''
        SELECT COUNT(*) as total
        FROM sales
        WHERE status = ?
      ''',
      [status.name],
    );

    return (result.first['total'] as int?) ?? 0;
  }

  Future<double> sumByStatuses(List<SaleStatusEnum> statuses) async {
    final placeholders = List.filled(statuses.length, '?').join(',');
    final result = await db.rawQuery('''
      SELECT SUM(totalSale) as total
      FROM sales
      WHERE status IN ($placeholders)
      ''', statuses.map((s) => s.name).toList());

    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<Map<String, double>> getSumByStatus() async {
    final result = await db.rawQuery('''
      SELECT status, SUM(totalSale) as total
      FROM sales
      GROUP BY status
    ''');

    return {
      for (var row in result)
        (row['status'] as String): (row['total'] as num?)?.toDouble() ?? 0.0,
    };
  }
}
