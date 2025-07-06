import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:management/core/models/app_exception.dart';
import 'package:management/core/models/base_form_provider.dart';
import 'package:management/core/services/app_toast_service.dart';
import 'package:management/modules/product/models/product_model.dart';
import 'package:management/modules/product/models/product_unit_entry_model.dart';
import 'package:management/modules/product/models/product_unit_model.dart';
import 'package:management/modules/product/repositories/product_repository.dart';
import 'package:management/shared/utils/utils.dart';

class ProductFormProvider
    extends BaseFormProvider<ProductModel, ProductRepository> {
  ProductFormProvider(super.repository);

  final nameController = TextEditingController();
  final brandController = TextEditingController();
  final groupController = TextEditingController();
  final barCodeController = TextEditingController();

  List<ProductUnitEntryModel> unitEntries = [];

  @override
  Future<void> loadData(ProductModel? model) async {
    try {
      this.model = model;

      nameController.text = model?.name ?? '';
      brandController.text = model?.brand ?? '';
      groupController.text = model?.group ?? '';
      barCodeController.text = model?.barCode ?? '';

      if (model?.id != null) {
        final rawUnits = await repository.getUnitsByProductId(model!.id!);
        unitEntries = rawUnits.map((u) {
          return ProductUnitEntryModel(
            unit: u,
            nameController: TextEditingController(text: u.name),
            priceController: TextEditingController(text: u.price!.toString()),
            stockController: TextEditingController(text: u.stock!.toString()),
          );
        }).toList();
      } else {
        unitEntries = [];
      }

      notifyListeners();
    } on AppException catch (e) {
      log("[ProductFormProvider]::loadData - ${e.message} - ${e.detail}");
      AppToastService.showError(e.message);
    } catch (e) {
      log("[ProductFormProvider]::loadData - $e");
      AppToastService.showError(
        'Erro desconhecido ao carregar os dados do produto',
      );
    }
  }

  void addUnit() {
    unitEntries.add(
      ProductUnitEntryModel(
        unit: ProductUnitModel(),
        nameController: TextEditingController(),
        priceController: TextEditingController(),
        stockController: TextEditingController(),
      ),
    );
    notifyListeners();
  }

  void removeUnit(int index) {
    unitEntries.removeAt(index);
    notifyListeners();
  }

  @override
  Future<bool?> save() async {
    if (!formKey.currentState!.validate()) return false;

    try {
      changeSaving();

      final isEdit = model != null;

      final product = ProductModel(
        id: model?.id,
        code: model?.code,
        name: nameController.text.trim(),
        brand: brandController.text.trim(),
        group: groupController.text.trim(),
        barCode: barCodeController.text.trim(),
        createdAt: model?.createdAt,
      );

      final units = unitEntries.map((entry) {
        return ProductUnitModel(
          id: entry.unit.id,
          code: entry.unit.code,
          name: entry.nameController.text.trim(),
          price: Utils.parseCurrency(entry.priceController.text),
          stock: Utils.parseCurrency(entry.stockController.text),
          createdAt: entry.unit.createdAt,
        );
      }).toList();

      if (isEdit) {
        await repository.update(product);
        await repository.replaceUnits(product.id!, units);
      } else {
        final productId = await repository.insert(product);
        await repository.insertUnits(productId, units);
      }

      AppToastService.showSuccess('Produto salvo com sucesso');
      return true;
    } on AppException catch (e) {
      log("[ProductFormProvider]::save - ${e.message} - ${e.detail}");
      AppToastService.showError(e.message);
      return false;
    } catch (e) {
      log("[ProductFormProvider]::save - $e");
      AppToastService.showError('Erro desconhecido ao salvar o produto');
      return false;
    } finally {
      changeSaving();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    brandController.dispose();
    groupController.dispose();
    barCodeController.dispose();

    for (var entry in unitEntries) {
      entry.nameController.dispose();
      entry.priceController.dispose();
      entry.stockController.dispose();
    }

    super.dispose();
  }
}
