import 'package:management/core/constants/app_table_names.dart';
import 'package:management/core/models/base_repository.dart';
import 'package:management/core/services/app_database_service.dart';
import 'package:management/modules/finance/models/finance_model.dart';

class FinanceRepository extends BaseRepository<FinanceModel> {
  FinanceRepository(AppDatabaseService db) : super(db, AppTableNames.finances);

  @override
  FinanceModel fromMap(Map<String, dynamic> map) {
    return FinanceModel().fromMap(map);
  }

  @override
  String? buildWhere(Map<String, dynamic>? filters) {
    if (filters == null || filters.isEmpty) return null;

    final conditions = <String>[];

    if (filters['code'] != null && filters['code'].toString().isNotEmpty) {
      conditions.add('code LIKE ?');
    }
    if (filters['customerName'] != null &&
        filters['customerName'].toString().isNotEmpty) {
      conditions.add('customerName LIKE ?');
    }
    if (filters['initialDate'] != null && filters['finalDate'] != null) {
      conditions.add('createdAt BETWEEN ? AND ?');
    } else if (filters['initialDate'] != null) {
      conditions.add('createdAt >= ?');
    } else if (filters['finalDate'] != null) {
      conditions.add('createdAt <= ?');
    }
    if (filters['type'] != null) {
      conditions.add('type = ?');
    }
    if (filters['status'] != null) {
      conditions.add('status = ?');
    }

    return conditions.isEmpty ? null : conditions.join(' AND ');
  }

  @override
  List<dynamic>? buildWhereArgs(Map<String, dynamic>? filters) {
    if (filters == null || filters.isEmpty) return null;
    final args = <dynamic>[];

    if (filters['code'] != null && filters['code'].toString().isNotEmpty) {
      args.add('%${filters['code']}%');
    }
    if (filters['customerName'] != null &&
        filters['customerName'].toString().isNotEmpty) {
      args.add('%${filters['customerName']}%');
    }

    final initialDate = (filters['initialDate'] as DateTime?)
        ?.toIso8601String();
    final finalDate = (filters['finalDate'] as DateTime?)
        ?.add(const Duration(days: 1))
        .toIso8601String();

    if (initialDate != null && finalDate != null) {
      args.add(initialDate);
      args.add(finalDate);
    } else if (initialDate != null) {
      args.add(initialDate);
    } else if (finalDate != null) {
      args.add(finalDate);
    }

    if (filters['type'] != null) args.add(filters['type']);
    if (filters['status'] != null) args.add(filters['status']);

    return args;
  }

  Future<void> syncWithSale(
    int? saleCode,
    double total,
    String customerName,
  ) async {
    final result = await db.rawQuery(
      'SELECT id FROM $tableName WHERE saleCode = ?',
      [saleCode],
    );

    if (result.isEmpty) {
      await db.insert(tableName, {
        'saleCode': saleCode,
        'customerName': customerName,
        'value': total,
        'type': FinanceTypeEnum.receivable.name,
        'status': FinanceStatusEnum.pending.name,
      });
    } else {
      final id = result.first['id'] as int;
      await db.update(tableName, {
        'value': total,
        'customerName': customerName,
        'status': FinanceStatusEnum.pending.name,
      }, id);
    }
  }
}
