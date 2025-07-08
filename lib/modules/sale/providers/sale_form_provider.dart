import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:management/core/models/app_exception.dart';
import 'package:management/core/models/base_form_provider.dart';
import 'package:management/core/services/app_toast_service.dart';
import 'package:management/modules/customer/models/customer_model.dart';
import 'package:management/modules/sale/models/sale_item_model.dart';
import 'package:management/modules/sale/models/sale_model.dart';
import 'package:management/modules/sale/models/sale_status_enum.dart';
import 'package:management/modules/sale/repositories/sale_repository.dart';
import 'package:management/shared/utils/utils.dart';

class SaleFormProvider extends BaseFormProvider<SaleModel, SaleRepository> {
  SaleFormProvider(super.repository);

  final discountPercentageController = TextEditingController();
  final discountValueController = TextEditingController();
  final totalItemsController = TextEditingController();
  final totalSaleController = TextEditingController();
  final notesController = TextEditingController();

  String paymentMethod = 'Dinheiro';
  String paymentCondition = 'À vista';

  SaleStatusEnum selectedStatus = SaleStatusEnum.open;

  final paymentMethodOptions = [
    'Dinheiro',
    'Cartão de Crédito',
    'Cartão de Débito',
    'PIX',
    'Boleto',
  ];

  final paymentConditionOptions = [
    'À vista',
    '30 dias',
    '2x sem juros',
    'Parcelado em 3x',
  ];

  CustomerModel customer = CustomerModel();
  final List<SaleItemModel> items = [];

  double get totalProducts =>
      items.fold(0.0, (sum, item) => sum + (item.subtotal ?? 0));

  double get discount =>
      Utils.parseToDouble(discountValueController.text == '' ? '0' : discountValueController.text)!;

  double get totalSale =>
      totalProducts - discount;
      
  @override
  Future<void> loadData(SaleModel? model) async {
    try {
      this.model = model;

      if (model != null) {
        paymentMethod = model.paymentMethod!;
        paymentCondition = model.paymentCondition!;
        selectedStatus = model.status;

        discountPercentageController.text =
            model.discountPercentage?.toString() ?? '';
        discountValueController.text = model.discountValue?.toString() ?? '';
        totalItemsController.text = model.totalProducts?.toString() ?? '';
        totalSaleController.text = model.totalSale?.toString() ?? '';
        notesController.text = model.notes?.toString() ?? '';

        if (model.id != null) {
          customer = await repository.getSaleCustomerById(model.customerId!);
          final saleItems = await repository.getItemsBySaleId(model.id!);
          items.addAll(saleItems);
        }

        _recalculateTotals();
      }

      notifyListeners();
    } on AppException catch (e) {
      AppToastService.showError(e.message);
    } catch (e) {
      AppToastService.showError('Erro desconhecido ao carregar a venda');
    }
  }

  void setCustomer(CustomerModel c) {
    customer = c;
    notifyListeners();
  }

  void setPaymentMethod(String? value) {
    paymentMethod = value!;
    notifyListeners();
  }

  void setPaymentCondition(String? value) {
    paymentCondition = value!;
    notifyListeners();
  }

  void setStatus(SaleStatusEnum? value) {
    selectedStatus = value ?? SaleStatusEnum.open;
    notifyListeners();
  }

  void addItem(SaleItemModel item) {
    items.add(item);
    _recalculateTotals();
    notifyListeners();
  }

  void removeItem(SaleItemModel item) {
    items.remove(item);
    _recalculateTotals();
    notifyListeners();
  }

  void updateItem(SaleItemModel item) {
    final index = items.indexWhere((i) => i.productId == item.productId);
    if (index != -1) {
      items[index] = item;
      _recalculateTotals();
      notifyListeners();
    }
  }

  void _recalculateTotals() {
    final discount = double.tryParse(discountValueController.text) ?? 0;
    final total = totalProducts - discount;

    totalItemsController.text = totalProducts.toStringAsFixed(2);
    totalSaleController.text = total.toStringAsFixed(2);
  }

  @override
  Future<bool?> save() async {
    if (!formKey.currentState!.validate()) return false;

    if (customer.id == null) {
      AppToastService.showError('Selecione um cliente');
      return false;
    }

    // if (items.isEmpty) {
    //   AppToastService.showError('Adicione ao menos um item');
    //   return false;
    // }

    try {
      changeSaving();

      final sale = SaleModel(
        id: model?.id,
        code: model?.code,
        customerId: customer.id,
        customerName: customer.name,
        paymentMethod: paymentMethod,
        paymentCondition: paymentCondition,
        discountPercentage: double.tryParse(discountPercentageController.text),
        discountValue: double.tryParse(discountValueController.text),
        totalProducts: totalProducts,
        totalSale: totalProducts,
        status: selectedStatus,
        notes: notesController.text.trim(),
        createdAt: model?.createdAt,
      );

      if (model == null) {
        final saleId = await repository.insert(sale);
        await repository.insertItems(saleId, items);
      } else {
        await repository.update(sale);
        await repository.replaceItems(sale.id!, items);
      }

      AppToastService.showSuccess('Registro salvo com sucesso');
      return true;
    } on AppException catch (e) {
      log("[SaleFormProvider]::save - ${e.message} - ${e.detail}");
      AppToastService.showError(e.message);
      return false;
    } catch (e) {
      log("[SaleFormProvider]::save - $e");
      AppToastService.showError('Erro desconhecido ao salvar a venda');
      return false;
    } finally {
      changeSaving();
    }
  }

  @override
  void dispose() {
    discountPercentageController.dispose();
    discountValueController.dispose();
    totalItemsController.dispose();
    totalSaleController.dispose();
    super.dispose();
  }
}
