class PaginatedResult<T> {
  final List<T> items;
  final int total;

  PaginatedResult({required this.items, required this.total});
}
