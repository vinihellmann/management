import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:management/core/constants/app_asset_names.dart';
import 'package:management/core/constants/app_table_names.dart';
import 'package:management/core/models/base_migration.dart';
import 'package:sqflite/sqflite.dart';

class Migration0002CreateStateCityTable extends BaseMigration {
  @override
  String get name => 'Migration0002CreateStateCityTable';

  @override
  Future<void> up(Database db) async {
    await db.execute('''
      CREATE TABLE ${AppTableNames.states} (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        acronym TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE ${AppTableNames.cities} (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        state_id INTEGER NOT NULL,
        FOREIGN KEY (state_id) REFERENCES ${AppTableNames.states} (id)
      );
    ''');

    final jsonStr = await rootBundle.loadString(AppAssetNames.jsonStateCity);
    final Map<String, dynamic> json = jsonDecode(jsonStr);

    final batch = db.batch();

    for (var state in json['estados']) {
      final stateId = state['id'];
      final stateName = state['nomeEstado'];
      final stateAcronym = state['sigla'];

      batch.insert(AppTableNames.states, {
        'id': stateId,
        'name': stateName,
        'acronym': stateAcronym,
      });

      for (var city in state['cidades']) {
        batch.insert(AppTableNames.cities, {
          'id': city['id_cidade'],
          'name': city['nomeCidade'],
          'state_id': stateId,
        });
      }
    }

    await batch.commit(noResult: true);
  }

  @override
  Future<void> down(Database db) async {
    await db.execute('DROP TABLE IF EXISTS ${AppTableNames.cities};');
    await db.execute('DROP TABLE IF EXISTS ${AppTableNames.states};');
  }
}
