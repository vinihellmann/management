import 'package:management/core/constants/app_table_names.dart';
import 'package:management/core/models/base_migration.dart';
import 'package:sqflite/sqflite.dart';

class Migration0005CreateSalesTable implements BaseMigration {
  @override
  String get name => 'Migration0005CreateSalesTable';

  @override
  Future<void> up(Database db) async {
    await db.execute('''
      CREATE TABLE ${AppTableNames.sales} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        code TEXT NOT NULL UNIQUE,
        customerId INTEGER NOT NULL,
        customerName TEXT NOT NULL,
        paymentMethod TEXT NOT NULL,
        paymentCondition TEXT NOT NULL,
        discountPercentage REAL,
        discountValue REAL,
        totalProducts REAL NOT NULL,
        totalSale REAL NOT NULL,
        notes TEXT,
        status TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        FOREIGN KEY (customerId) REFERENCES ${AppTableNames.customers}(id) ON DELETE SET NULL
      )
    ''');
  }

  @override
  Future<void> down(Database db) async {
    await db.execute('DROP TABLE IF EXISTS ${AppTableNames.sales};');
  }
}
