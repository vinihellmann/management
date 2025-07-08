import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:management/core/models/app_exception.dart';
import 'package:management/core/models/base_filters.dart';
import 'package:management/core/models/base_model.dart';
import 'package:management/core/models/base_repository.dart';
import 'package:management/core/services/app_toast_service.dart';

abstract class BaseListProvider<
  T extends BaseModel,
  R extends BaseRepository<T>,
  F extends BaseFilters
>
    extends ChangeNotifier {
  final R repository;
  final F filters;

  List<T> items = [];
  bool isLoading = false;
  int currentPage = 1;
  int pageSize = 10;
  int totalItems = 0;
  String orderBy = 'code ASC';

  BaseListProvider(this.repository, this.filters);

  bool get hasMore => currentPage * pageSize < totalItems;
  int get totalItemsShown => (currentPage - 1) * pageSize + items.length;
  int get totalPages => (totalItems / pageSize).ceil();

  Future<void> getData([bool showLoading = true]) async {
    try {
      changeLoading(showLoading);

      final result = await repository.getAll(
        page: currentPage,
        pageSize: pageSize,
        filters: filters.toMap(),
        orderBy: orderBy,
      );

      items = result.items;
      totalItems = result.total;
    } on AppException catch (e) {
      log("[BaseListProvider]::getData - ${e.message} - ${e.detail}");
      AppToastService.showError(e.message);
    } catch (e) {
      log("[BaseListProvider]::getData - $e");
      AppToastService.showError('Erro desconhecido ao buscar os registros');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> nextPage() async {
    currentPage++;
    getData(false);
  }

  Future<void> previousPage() async {
    if (currentPage > 1) {
      currentPage--;
      getData(false);
    }
  }

  void clearFilters() {
    currentPage = 1;
    filters.clear();
    orderBy = 'code ASC';
    getData();
  }

  void updateFilter(String key, String? value) {
    filters.update(key, value);
  }

  void changeLoading(bool reflectUI) {
    isLoading = !isLoading;
    if (reflectUI) notifyListeners();
  }
}
