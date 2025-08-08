import 'dart:developer';

import 'package:management/core/constants/app_table_names.dart';
import 'package:management/core/database/migrations/migration_0001_create_customers_table.dart';
import 'package:management/core/database/migrations/migration_0002_create_state_city_table.dart';
import 'package:management/core/database/migrations/migration_0003_create_products_table.dart';
import 'package:management/core/database/migrations/migration_0004_create_product_units_table.dart';
import 'package:management/core/database/migrations/migration_0005_create_sales_table.dart';
import 'package:management/core/database/migrations/migration_0006_create_sale_items_table.dart';
import 'package:management/core/database/migrations/migration_0007_create_finances_table.dart';
import 'package:management/core/models/base_migration.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase() => _instance;
  AppDatabase._internal();

  static const _dbName = 'management.db';
  static const _dbVersion = 1;

  Database? _database;

  Future<Database> get database async {
    return _database ??= await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await _createMigrationTable(db);
        await _runMigrations(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await _runMigrations(db);
      },
    );
  }

  Future<void> _createMigrationTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${AppTableNames.migrations} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE
      )
    ''');
  }

  Future<void> _runMigrations(Database db) async {
    final appliedMg = await db.query(
      AppTableNames.migrations,
      columns: ['name'],
    );

    final appliedNames = appliedMg.map((e) => e['name'] as String).toSet();

    final allMigrations = <BaseMigration>[
      Migration0001CreateCustomersTable(),
      Migration0002CreateStateCityTable(),
      Migration0003CreateProductsTable(),
      Migration0004CreateProductUnitsTable(),
      Migration0005CreateSalesTable(),
      Migration0006CreateSaleItemsTable(),
      Migration0007CreateFinancesTable(),
    ];

    for (final migration in allMigrations) {
      if (!appliedNames.contains(migration.name)) {
        await migration.up(db);
        await db.insert(AppTableNames.migrations, {'name': migration.name});
        log("[MIGRATION] EXEC ${migration.name}");
      }
    }
  }
}
