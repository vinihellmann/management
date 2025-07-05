import 'package:sqflite/sqflite.dart';

abstract class BaseMigration {
  String get name;
  Future<void> up(Database db);
  Future<void> down(Database db);
}
