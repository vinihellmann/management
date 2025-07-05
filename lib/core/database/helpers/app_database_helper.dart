import 'package:sqflite/sqflite.dart';

class AppDatabaseHelper {
  static Future<String> nowIso() async {
    return DateTime.now().toIso8601String();
  }

  static Future<String> generateNextCode(Database db, String table) async {
    final result = await db.rawQuery(
      'SELECT MAX(code) as max_code FROM $table',
    );
    
    final maxCode = result.first['max_code'] as String?;
    final next = (int.tryParse(maxCode ?? '0') ?? 0) + 1;
    return next.toString().padLeft(4, '0');
  }
}
