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
        customerId INTEGER,
        customerName TEXT,
        paymentMethod TEXT,
        paymentCondition TEXT,
        discountPercentage REAL,
        discountValue REAL,
        totalProducts REAL,
        total REAL,
        status TEXT,
        createdAt TEXT,
        updatedAt TEXT,
        FOREIGN KEY (customerId) REFERENCES ${AppTableNames.customers}(id) ON DELETE SET NULL
      )
    ''');
  }

  @override
  Future<void> down(Database db) async {
    await db.execute('DROP TABLE IF EXISTS ${AppTableNames.sales};');
  }
}
