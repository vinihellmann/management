import 'package:flutter/material.dart';
import 'package:management/core/models/base_form_provider.dart';
import 'package:management/modules/customer/models/customer_city_model.dart';
import 'package:management/modules/customer/models/customer_model.dart';
import 'package:management/modules/customer/models/customer_state_model.dart';
import 'package:management/modules/customer/repositories/customer_repository.dart';

class CustomerFormProvider
    extends BaseFormProvider<CustomerModel, CustomerRepository> {
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

  CustomerFormProvider(super.repository);

  Future<void> loadStates() async {
    states = await repository.getAllStates();
    notifyListeners();
  }

  Future<void> selectState(CustomerStateModel? state) async {
    if (state == null) return;

    selectedState = state;
    cities = await repository.getCitiesByStateId(state.id);
    selectedCity = null;
    notifyListeners();
  }

  void selectCity(CustomerCityModel? city) {
    if (city == null) return;

    selectedCity = city;
    notifyListeners();
  }

  @override
  Future<void> loadData(CustomerModel? model) async {
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
      final state = states.firstWhere(
        (s) => s.acronym == model!.state,
        orElse: () => states.first,
      );

      await selectState(state);
    }

    if (model?.city != null && cities.isNotEmpty) {
      final city = cities.firstWhere(
        (c) => c.name == model!.city,
        orElse: () => cities.first,
      );

      selectCity(city);
    }
  }

  @override
  Future<bool?> save() async {
    if (!formKey.currentState!.validate()) return false;

    isSaving = true;
    notifyListeners();

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

    isSaving = false;
    notifyListeners();
    return true;
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
