abstract class BaseRepository<T> {
  Future<List<T>> getAll({
    int page = 1,
    int pageSize = 10,
    Map<String, dynamic>? filters,
  });

  Future<T?> getById(int id);
  Future<int> insert(T model);
  Future<int> update(T model);
  Future<int> delete(int id);

  String? buildWhere(Map<String, dynamic>? filters) {
    if (filters == null || filters.isEmpty) return null;
    return filters.keys.map((key) => '$key LIKE ?').join(' AND ');
  }

  List<dynamic>? buildWhereArgs(Map<String, dynamic>? filters) {
    if (filters == null || filters.isEmpty) return null;
    return filters.values.map((value) => '%$value%').toList();
  }
}
