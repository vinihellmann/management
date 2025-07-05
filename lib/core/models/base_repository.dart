import 'package:management/core/models/app_exception.dart';
import 'package:management/core/models/base_model.dart';
import 'package:management/core/models/paginated_result.dart';
import 'package:management/core/services/app_database_service.dart';
import 'package:sqflite/sqflite.dart';

abstract class BaseRepository<T extends BaseModel> {
  final AppDatabaseService db;
  final String tableName;

  BaseRepository(this.db, this.tableName);

  T fromMap(Map<String, dynamic> map);

  Future<PaginatedResult<T>> getAll({
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

      final total = Sqflite.firstIntValue(countResult) ?? 0;

      return PaginatedResult(
        items: result.map((map) => fromMap(map)).toList(),
        total: total,
      );
    } catch (e, stack) {
      throw AppException(
        'Ocorreu um erro ao buscar os registros',
        detail: e.toString(),
        stackTrace: stack,
      );
    }
  }

  Future<T?> getById(int id) async {
    try {
      final map = await db.getById(tableName, id);
      return map != null ? fromMap(map) : null;
    } catch (e, stack) {
      throw AppException(
        'Ocorreu um erro ao buscar o registro',
        detail: e.toString(),
        stackTrace: stack,
      );
    }
  }

  Future<int> insert(T model) {
    try {
      return db.insert(tableName, model.toMap());
    } catch (e, stack) {
      throw AppException(
        'Ocorreu um erro ao inserir o registro',
        detail: e.toString(),
        stackTrace: stack,
      );
    }
  }

  Future<int> update(T model) {
    try {
      if (model.id == null) throw Exception('ID obrigatório para atualização');
      return db.update(tableName, model.toMap(), model.id!);
    } catch (e, stack) {
      throw AppException(
        'Ocorreu um erro ao atualizar o registro',
        detail: e.toString(),
        stackTrace: stack,
      );
    }
  }

  Future<int> delete(int id) {
    try {
      return db.delete(tableName, id);
    } catch (e, stack) {
      throw AppException(
        'Ocorreu um erro ao deletar o registro',
        detail: e.toString(),
        stackTrace: stack,
      );
    }
  }

  String? buildWhere(Map<String, dynamic>? filters) {
    if (filters == null || filters.isEmpty) return null;
    return filters.keys.map((key) => '$key LIKE ?').join(' AND ');
  }

  List<dynamic>? buildWhereArgs(Map<String, dynamic>? filters) {
    if (filters == null || filters.isEmpty) return null;
    return filters.values.map((value) => '%$value%').toList();
  }
}
