import 'package:management/core/constants/app_table_names.dart';
import 'package:management/core/models/base_migration.dart';
import 'package:sqflite/sqflite.dart';

class Migration0006CreateSaleItemsTable implements BaseMigration {
  @override
  String get name => 'Migration0006CreateSaleItemsTable';

  @override
  Future<void> up(Database db) async {
    await db.execute('''
      CREATE TABLE ${AppTableNames.saleItems} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        code TEXT NOT NULL UNIQUE,
        saleId INTEGER NOT NULL,
        productId INTEGER NOT NULL,
        productName TEXT NOT NULL,
        unitId INTEGER NOT NULL,
        unitName TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        unitPrice REAL NOT NULL,
        subtotal REAL NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        FOREIGN KEY (saleId) REFERENCES ${AppTableNames.sales}(id) ON DELETE CASCADE,
        FOREIGN KEY (productId) REFERENCES ${AppTableNames.products}(id) ON DELETE SET NULL,
        FOREIGN KEY (unitId) REFERENCES ${AppTableNames.productUnits}(id) ON DELETE SET NULL
      )
    ''');
  }

  @override
  Future<void> down(Database db) async {
    await db.execute('DROP TABLE IF EXISTS ${AppTableNames.saleItems};');
  }
}
