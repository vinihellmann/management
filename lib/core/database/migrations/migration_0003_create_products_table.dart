import 'package:management/core/constants/app_table_names.dart';
import 'package:management/core/models/base_migration.dart';
import 'package:sqflite/sqflite.dart';

class Migration0003CreateProductsTable implements BaseMigration {
  @override
  String get name => 'Migration0003CreateProductsTable';

  @override
  Future<void> up(Database db) async {
    await db.execute('''
      CREATE TABLE ${AppTableNames.products} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        code TEXT NOT NULL UNIQUE,
        barCode TEXT,
        name TEXT NOT NULL,
        brand TEXT,
        "group" TEXT,
        description TEXT,
        createdAt TEXT,
        updatedAt TEXT
      )
    ''');
  }

  @override
  Future<void> down(Database db) async {
    await db.execute('DROP TABLE IF EXISTS ${AppTableNames.products};');
  }
}
