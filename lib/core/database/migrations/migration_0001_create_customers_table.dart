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
        document TEXT NOT NULL,
        email TEXT,
        phone TEXT,
        address TEXT NOT NULL,
        neighborhood TEXT NOT NULL,
        number TEXT NOT NULL,
        city TEXT NOT NULL,
        state TEXT NOT NULL,
        contact TEXT,
        zipcode TEXT NOT NULL,
        complement TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');
  }

  @override
  Future<void> down(Database db) async {
    await db.execute('DROP TABLE IF EXISTS ${AppTableNames.customers};');
  }
}
