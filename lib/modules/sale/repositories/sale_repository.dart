import 'package:management/core/constants/app_table_names.dart';
import 'package:management/core/models/app_exception.dart';
import 'package:management/core/models/base_repository.dart';
import 'package:management/core/models/paginated_result.dart';
import 'package:management/core/services/app_database_service.dart';
import 'package:management/modules/sale/models/sale_item_model.dart';
import 'package:management/modules/sale/models/sale_model.dart';
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
}
