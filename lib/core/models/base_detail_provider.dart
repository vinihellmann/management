import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:management/core/models/app_exception.dart';
import 'package:management/core/models/base_model.dart';
import 'package:management/core/models/base_repository.dart';
import 'package:management/core/services/app_toast_service.dart';

abstract class BaseDetailProvider<
  T extends BaseModel,
  R extends BaseRepository<T>
>
    extends ChangeNotifier {
  final R repository;
  bool isDeleting = false;

  BaseDetailProvider(this.repository);

  Future<void> delete(T? model) async {
    try {
      if (model?.id == null) return;

      changeDeleting();
      await repository.delete(model!.id!);
      AppToastService.showSuccess('Registro excluído com sucesso');
    } on AppException catch (e) {
      log("[BaseDetailProvider]::delete - ${e.message} - ${e.detail}");
      AppToastService.showError(e.message);
    } catch (e) {
      log("[BaseDetailProvider]::delete - $e");
      AppToastService.showError('Erro desconhecido ao excluir o registro');
    } finally {
      changeDeleting();
    }
  }

  void changeDeleting() {
    isDeleting = !isDeleting;
    notifyListeners();
  }
}
