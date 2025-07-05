import 'package:management/core/models/base_model.dart';
import 'package:management/core/models/paginated_result.dart';
import 'package:management/core/services/app_database_service.dart';
import 'package:sqflite/sqflite.dart';

abstract class BaseRepository<T extends BaseModel> {
  final AppDatabaseService db;
  final String tableName;

  BaseRepository(this.db, this.tableName);

  String get defaultOrderBy => 'id ASC';

  T fromMap(Map<String, dynamic> map);

  Future<PaginatedResult<T>> getAll({
    int page = 1,
    int pageSize = 10,
    Map<String, dynamic>? filters,
    String? orderBy,
  }) async {
    final offset = (page - 1) * pageSize;

    final where = buildWhere(filters);
    final whereArgs = buildWhereArgs(filters);

    final result = await db.query(
      tableName,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy ?? defaultOrderBy,
      limit: pageSize,
      offset: offset,
    );

    final countResult = await db.rawQuery('''
      SELECT COUNT(*) as total
      FROM $tableName
      ${where != null ? 'WHERE $where' : ''}
      ''', whereArgs);

    final total = Sqflite.firstIntValue(countResult) ?? 0;

    return PaginatedResult(
      items: result.map((map) => fromMap(map)).toList(),
      total: total,
    );
  }

  Future<T?> getById(int id) async {
    final map = await db.getById(tableName, id);
    return map != null ? fromMap(map) : null;
  }

  Future<int> insert(T model) {
    return db.insert(tableName, model.toMap());
  }

  Future<int> update(T model) {
    if (model.id == null) throw Exception('ID obrigatório para atualização');
    return db.update(tableName, model.toMap(), model.id!);
  }

  Future<int> delete(int id) {
    return db.delete(tableName, id);
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
