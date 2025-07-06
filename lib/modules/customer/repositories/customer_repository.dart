import 'package:management/core/constants/app_table_names.dart';
import 'package:management/core/models/app_exception.dart';
import 'package:management/core/models/base_repository.dart';
import 'package:management/core/services/app_database_service.dart';
import 'package:management/modules/customer/models/customer_city_model.dart';
import 'package:management/modules/customer/models/customer_model.dart';
import 'package:management/modules/customer/models/customer_state_model.dart';
import 'package:sqflite/sqflite.dart';

class CustomerRepository extends BaseRepository<CustomerModel> {
  CustomerRepository(AppDatabaseService db)
    : super(db, AppTableNames.customers);

  @override
  CustomerModel fromMap(Map<String, dynamic> map) {
    return CustomerModel().fromMap(map);
  }

  Future<List<CustomerStateModel>> getAllStates() async {
    try {
      final result = await db.rawQuery(
        'SELECT * FROM ${AppTableNames.states} ORDER BY name',
      );

      return result.map(CustomerStateModel.fromMap).toList();
    } catch (e, stack) {
      throw AppException(
        'Ocorreu um erro ao buscar os estados',
        detail: e.toString(),
        stackTrace: stack,
      );
    }
  }

  Future<List<CustomerCityModel>> getCitiesByStateId(int stateId) async {
    try {
      final result = await db.rawQuery(
        'SELECT * FROM ${AppTableNames.cities} WHERE state_id = ? ORDER BY name',
        [stateId],
      );

      return result.map(CustomerCityModel.fromMap).toList();
    } catch (e, stack) {
      throw AppException(
        'Ocorreu um erro ao buscar as cidades',
        detail: e.toString(),
        stackTrace: stack,
      );
    }
  }

  Future<int> count() async {
    try {
      final result = await db.rawQuery(
        'SELECT COUNT(*) as total FROM customers',
      );
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e, stack) {
      throw AppException(
        'Ocorreu um erro ao buscar a contagem de clientes',
        detail: e.toString(),
        stackTrace: stack,
      );
    }
  }
}
