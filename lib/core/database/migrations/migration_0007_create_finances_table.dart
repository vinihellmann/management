import 'package:management/core/constants/app_table_names.dart';
import 'package:management/core/models/base_migration.dart';
import 'package:sqflite/sqflite.dart';

class Migration0007CreateFinancesTable implements BaseMigration {
  @override
  String get name => 'Migration0007CreateFinancesTable';

  @override
  Future<void> up(Database db) async {
    await db.execute('''
      CREATE TABLE ${AppTableNames.finances} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        code TEXT NOT NULL UNIQUE,
        saleCode TEXT,
        customerId INTEGER,
        customerName TEXT,
        value REAL NOT NULL,
        dueDate TEXT,
        type TEXT NOT NULL,
        status TEXT NOT NULL,
        notes TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        FOREIGN KEY (saleCode) REFERENCES ${AppTableNames.sales}(code) ON DELETE CASCADE,
        FOREIGN KEY (customerId) REFERENCES ${AppTableNames.customers}(id) ON DELETE SET NULL
      )
    ''');
  }

  @override
  Future<void> down(Database db) async {
    await db.execute('DROP TABLE IF EXISTS ${AppTableNames.finances};');
  }
}
