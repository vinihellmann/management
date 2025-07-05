import 'package:management/core/database/app_database.dart';
import 'package:management/core/database/helpers/app_database_helper.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabaseService {
  Future<void> init() async {
    _db = await AppDatabase().database;
  }

  late final Database _db;
  Database get db => _db;

  Future<List<Map<String, dynamic>>> rawQuery(String sql, [List<Object?>? arguments]) {
    return _db.rawQuery(sql, arguments);
  }

  Future<List<Map<String, dynamic>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<dynamic>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) {
    return _db.query(
      table,
      distinct: distinct,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  Future<int> insert(String table, Map<String, dynamic> values) async {
    values['createdAt'] = DateTime.now().toIso8601String();
    values['updatedAt'] = DateTime.now().toIso8601String();

    if (values['code'] == null) {
      values['code'] = await AppDatabaseHelper.generateNextCode(_db, table);
    }

    return _db.insert(table, values);
  }

  Future<int> update(String table, Map<String, dynamic> values, int id) async {
    values['updatedAt'] = DateTime.now().toIso8601String();

    return _db.update(table, values, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(String table, int id) {
    return _db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>?> getById(String table, int id) async {
    final result = await _db.query(table, where: 'id = ?', whereArgs: [id]);

    if (result.isEmpty) return null;
    return result.first;
  }

  Future<String> generateNextCode(String table) async {
    return AppDatabaseHelper.generateNextCode(_db, table);
  }
}
