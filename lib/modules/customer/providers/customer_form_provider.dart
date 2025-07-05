import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:management/core/models/app_exception.dart';
import 'package:management/core/models/base_form_provider.dart';
import 'package:management/core/services/app_toast_service.dart';
import 'package:management/core/services/app_zip_service.dart';
import 'package:management/modules/customer/models/customer_city_model.dart';
import 'package:management/modules/customer/models/customer_model.dart';
import 'package:management/modules/customer/models/customer_state_model.dart';
import 'package:management/modules/customer/repositories/customer_repository.dart';

class CustomerFormProvider
    extends BaseFormProvider<CustomerModel, CustomerRepository> {
  final AppZipService zipService;

  final nameController = TextEditingController();
  final fantasyController = TextEditingController();
  final documentController = TextEditingController();
  final addressController = TextEditingController();
  final neighborhoodController = TextEditingController();
  final numberController = TextEditingController();
  final zipController = TextEditingController();
  final complementController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final contactController = TextEditingController();

  List<CustomerStateModel> states = [];
  List<CustomerCityModel> cities = [];

  CustomerStateModel? selectedState;
  CustomerCityModel? selectedCity;

  CustomerFormProvider(super.repository, this.zipService);

  Future<void> fillAddress() async {
    try {
      final rawZipCode = zipController.text.trim();
      final cleanZipCode = rawZipCode.replaceAll(RegExp(r'[^0-9]'), '');

      if (cleanZipCode.isEmpty) {
        AppToastService.showError('Informe o CEP');
        return;
      }

      if (cleanZipCode.length != 8) {
        AppToastService.showError('Formato de CEP inválido');
        return;
      }

      final zip = await zipService.fetchZipCode(cleanZipCode);

      if (zip == null) {
        AppToastService.showError('CEP não encontrado');
        return;
      }

      addressController.text = zip.street;
      neighborhoodController.text = zip.neighborhood;

      final state = findState(zip.state);
      await selectState(state);

      final city = findCity(zip.city);
      selectCity(city);

      notifyListeners();
    } on AppException catch (e) {
      log("[CustomerFormProvider]::fillAddress - ${e.message} - ${e.detail}");
      AppToastService.showError(e.message);
    } catch (e) {
      log("[CustomerFormProvider]::fillAddress - $e");
      AppToastService.showError('Erro desconhecido ao buscar o CEP');
    }
  }

  Future<void> loadStates() async {
    try {
      states = await repository.getAllStates();
      notifyListeners();
    } on AppException catch (e) {
      log("[CustomerFormProvider]::loadStates - ${e.message} - ${e.detail}");
      AppToastService.showError(e.message);
    } catch (e) {
      log("[CustomerFormProvider]::loadStates - $e");
      AppToastService.showError('Erro desconhecido ao carregar os estados');
    }
  }

  Future<void> selectState(CustomerStateModel? state) async {
    try {
      if (state == null) return;

      selectedState = state;
      cities = await repository.getCitiesByStateId(state.id);
      selectedCity = null;
      notifyListeners();
    } on AppException catch (e) {
      log("[CustomerFormProvider]::selectState - ${e.message} - ${e.detail}");
      AppToastService.showError(e.message);
    } catch (e) {
      log("[CustomerFormProvider]::selectState - $e");
      AppToastService.showError('Erro desconhecido ao selecionar o estado');
    }
  }

  void selectCity(CustomerCityModel? city) {
    if (city == null) return;

    selectedCity = city;
    notifyListeners();
  }

  CustomerStateModel findState(String? state) {
    return states.firstWhere(
      (s) => s.acronym == state,
      orElse: () => states.first,
    );
  }

  CustomerCityModel findCity(String? city) {
    return cities.firstWhere((c) => c.name == city, orElse: () => cities.first);
  }

  @override
  Future<void> loadData(CustomerModel? model) async {
    try {
      this.model = model;

      nameController.text = model?.name ?? '';
      fantasyController.text = model?.fantasy ?? '';
      documentController.text = model?.document ?? '';
      emailController.text = model?.email ?? '';
      phoneController.text = model?.phone ?? '';
      addressController.text = model?.address ?? '';
      neighborhoodController.text = model?.neighborhood ?? '';
      numberController.text = model?.number ?? '';
      zipController.text = model?.zipcode ?? '';
      complementController.text = model?.complement ?? '';
      contactController.text = model?.contact ?? '';

      await loadStates();

      if (model?.state != null) {
        final state = findState(model?.state);
        await selectState(state);
      }

      if (model?.city != null && cities.isNotEmpty) {
        final city = findCity(model?.city);
        selectCity(city);
      }
    } on AppException catch (e) {
      log("[CustomerFormProvider]::loadData - ${e.message} - ${e.detail}");
      AppToastService.showError(e.message);
    } catch (e) {
      log("[CustomerFormProvider]::loadData - $e");
      AppToastService.showError('Erro desconhecido ao carregar os dados');
    }
  }

  @override
  Future<bool?> save() async {
    if (!formKey.currentState!.validate()) return false;

    try {
      changeSaving();

      final isEdit = model != null;

      final customer = CustomerModel(
        id: model?.id,
        code: model?.code,
        name: nameController.text.trim(),
        fantasy: fantasyController.text.trim(),
        document: documentController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        address: addressController.text.trim(),
        neighborhood: neighborhoodController.text.trim(),
        number: numberController.text.trim(),
        zipcode: zipController.text.trim(),
        complement: complementController.text.trim(),
        contact: contactController.text.trim(),
        city: selectedCity?.name,
        state: selectedState?.acronym,
        createdAt: model?.createdAt,
      );

      if (isEdit) {
        await repository.update(customer);
      } else {
        await repository.insert(customer);
      }

      AppToastService.showSuccess('Registro salvo com sucesso');
      return true;
    } on AppException catch (e) {
      log("[CustomerFormProvider]::save - ${e.message} - ${e.detail}");
      AppToastService.showError(e.message);
      return false;
    } catch (e) {
      log("[CustomerFormProvider]::save - $e");
      AppToastService.showError('Erro desconhecido ao salvar o registro');
      return false;
    } finally {
      changeSaving();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    fantasyController.dispose();
    documentController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    neighborhoodController.dispose();
    numberController.dispose();
    zipController.dispose();
    complementController.dispose();
    contactController.dispose();
    super.dispose();
  }
}
