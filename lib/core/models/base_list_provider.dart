import 'package:flutter/material.dart';
import 'package:management/core/models/base_filters.dart';
import 'package:management/core/models/base_model.dart';
import 'package:management/core/models/base_repository.dart';

abstract class BaseListProvider<T extends BaseModel, F extends BaseFilters>
    extends ChangeNotifier {
  final BaseRepository<T> repository;
  final F filters;

  List<T> items = [];
  bool isLoading = false;
  int currentPage = 1;
  int pageSize = 10;
  int totalItems = 0;

  bool get hasMore => items.length == pageSize;

  BaseListProvider(this.repository, this.filters);

  Future<void> getData() async {
    isLoading = true;
    notifyListeners();

    final result = await repository.getAll(
      page: currentPage,
      pageSize: pageSize,
      filters: filters.toMap(),
    );

    items = result;
    isLoading = false;
    notifyListeners();
  }

  void updateFilter(String key, String? value) {
    filters.update(key, value);
  }

  void nextPage() {
    currentPage++;
    getData();
  }

  void previousPage() {
    if (currentPage > 1) {
      currentPage--;
      getData();
    }
  }

  void clearFilters() {
    currentPage = 1;
    filters.clear();
    getData();
  }
}
