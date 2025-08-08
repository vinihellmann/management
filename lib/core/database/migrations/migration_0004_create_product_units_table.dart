import 'package:management/core/constants/app_table_names.dart';
import 'package:management/core/models/base_migration.dart';
import 'package:sqflite/sqflite.dart';

class Migration0004CreateProductUnitsTable implements BaseMigration {
  @override
  String get name => 'Migration0004CreateProductUnitsTable';

  @override
  Future<void> up(Database db) async {
    await db.execute('''
      CREATE TABLE ${AppTableNames.productUnits} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        code TEXT NOT NULL UNIQUE,
        productId INTEGER NOT NULL,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        stock INTEGER NOT NULL,
        isDefault INTEGER NOT NULL DEFAULT 0,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        FOREIGN KEY (productId) REFERENCES ${AppTableNames.products}(id) ON DELETE CASCADE
      )
    ''');
  }

  @override
  Future<void> down(Database db) async {
    await db.execute('DROP TABLE IF EXISTS ${AppTableNames.productUnits};');
  }
}
