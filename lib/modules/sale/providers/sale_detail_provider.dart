import 'dart:developer';

import 'package:management/core/models/app_exception.dart';
import 'package:management/core/models/base_detail_provider.dart';
import 'package:management/core/services/app_toast_service.dart';
import 'package:management/modules/sale/models/sale_item_model.dart';
import 'package:management/modules/sale/models/sale_model.dart';
import 'package:management/modules/sale/repositories/sale_repository.dart';

class SaleDetailProvider extends BaseDetailProvider<SaleModel, SaleRepository> {
  SaleDetailProvider(super.repository);

  List<SaleItemModel> items = [];

  Future<void> loadItems(List<SaleItemModel> saleItems) async {
    items = saleItems;
    notifyListeners();
  }

  Future<bool> markAsSent(int saleId) async {
    try {
      await repository.markAsSent(saleId);
      return true;
    } on AppException catch (e) {
      log("[SaleDetailProvider]::markAsSent - ${e.message} - ${e.detail}");
      AppToastService.showError(e.message);
      return false;
    } catch (e) {
      log("[SaleDetailProvider]::markAsSent - $e");
      AppToastService.showError('Erro desconhecido ao marcar a venda como Enviada');
      return false;
    }
  }

  Future<bool> markAsCompleted(int saleId) async {
    try {
      await repository.markAsCompleted(saleId);
      return true;
    } on AppException catch (e) {
      log("[SaleDetailProvider]::markAsCompleted - ${e.message} - ${e.detail}");
      AppToastService.showError(e.message);
      return false;
    } catch (e) {
      log("[SaleDetailProvider]::markAsCompleted - $e");
      AppToastService.showError('Erro desconhecido ao concluir a venda');
      return false;
    }
  }

  Future<bool> markAsCanceled(int saleId) async {
    try {
      await repository.markAsCanceled(saleId);
      return true;
    } on AppException catch (e) {
      log("[SaleDetailProvider]::markAsCanceled - ${e.message} - ${e.detail}");
      AppToastService.showError(e.message);
      return false;
    } catch (e) {
      log("[SaleDetailProvider]::markAsCanceled - $e");
      AppToastService.showError('Erro desconhecido ao cancelar a venda');
      return false;
    }
  }
}
