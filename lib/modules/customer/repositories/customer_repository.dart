import 'package:management/core/constants/app_table_names.dart';
import 'package:management/core/models/base_repository.dart';
import 'package:management/core/services/app_database_service.dart';
import 'package:management/modules/customer/models/customer_city_model.dart';
import 'package:management/modules/customer/models/customer_model.dart';
import 'package:management/modules/customer/models/customer_state_model.dart';

class CustomerRepository extends BaseRepository<CustomerModel> {
  final AppDatabaseService db;

  CustomerRepository(this.db);

  @override
  Future<List<CustomerModel>> getAll({
    int page = 1,
    int pageSize = 10,
    Map<String, dynamic>? filters,
  }) async {
    final offset = (page - 1) * pageSize;

    final result = await db.query(
      AppTableNames.customers,
      where: buildWhere(filters),
      whereArgs: buildWhereArgs(filters),
      orderBy: 'name ASC',
      limit: pageSize,
      offset: offset,
    );

    return result.map(CustomerModel().fromMap).toList();
  }

  @override
  Future<CustomerModel?> getById(int id) async {
    final map = await db.getById(AppTableNames.customers, id);
    return map != null ? CustomerModel().fromMap(map) : null;
  }

  @override
  Future<int> insert(CustomerModel model) async {
    return db.insert(AppTableNames.customers, model.toMap());
  }

  @override
  Future<int> update(CustomerModel model) async {
    if (model.id == null) throw Exception('ID obrigatório para atualização');
    return db.update(AppTableNames.customers, model.toMap(), model.id!);
  }

  @override
  Future<int> delete(int id) async {
    return db.delete(AppTableNames.customers, id);
  }

  Future<List<CustomerStateModel>> getAllStates() async {
    final result = await db.rawQuery(
      'SELECT * FROM ${AppTableNames.states} ORDER BY name',
    );
    return result.map((e) => CustomerStateModel.fromMap(e)).toList();
  }

  Future<List<CustomerCityModel>> getCitiesByStateId(int stateId) async {
    final result = await db.rawQuery(
      'SELECT * FROM ${AppTableNames.cities} WHERE state_id = $stateId ORDER BY name',
    );
    return result.map((e) => CustomerCityModel.fromMap(e)).toList();
  }
}
