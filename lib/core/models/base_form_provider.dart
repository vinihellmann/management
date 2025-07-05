import 'package:flutter/material.dart';
import 'package:management/core/models/base_model.dart';
import 'package:management/core/models/base_repository.dart';

abstract class BaseFormProvider<
  T extends BaseModel,
  R extends BaseRepository<T>
>
    extends ChangeNotifier {
  final R repository;

  BaseFormProvider(this.repository);

  final formKey = GlobalKey<FormState>();
  bool isSaving = false;
  T? model;

  void loadData(T? model);
  Future<bool?> save();
}
