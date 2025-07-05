import 'package:management/core/constants/app_table_names.dart';
import 'package:management/core/models/base_migration.dart';
import 'package:sqflite/sqflite.dart';

class Migration0001CreateCustomersTable implements BaseMigration {
  @override
  String get name => 'Migration0001CreateCustomersTable';

  @override
  Future<void> up(Database db) async {
    await db.execute('''
      CREATE TABLE ${AppTableNames.customers} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        code TEXT NOT NULL UNIQUE,
        name TEXT NOT NULL,
        fantasy TEXT,
        document TEXT,
        email TEXT,
        phone TEXT,
        address TEXT,
        neighborhood TEXT,
        number TEXT,
        city TEXT,
        state TEXT,
        contact TEXT,
        zipcode TEXT,
        complement TEXT,
        createdAt TEXT,
        updatedAt TEXT
      )
    ''');
  }

  @override
  Future<void> down(Database db) async {
    await db.execute('DROP TABLE IF EXISTS ${AppTableNames.customers};');
  }
}
