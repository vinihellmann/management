import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:management/core/components/app_button.dart';
import 'package:management/core/components/app_layout.dart';
import 'package:management/core/components/app_select.dart';
import 'package:management/core/components/app_text_field.dart';
import 'package:management/modules/customer/models/customer_city_model.dart';
import 'package:management/modules/customer/models/customer_model.dart';
import 'package:management/modules/customer/models/customer_state_model.dart';
import 'package:management/modules/customer/providers/customer_form_provider.dart';
import 'package:management/modules/customer/repositories/customer_repository.dart';
import 'package:provider/provider.dart';

class CustomerFormPage extends StatelessWidget {
  final CustomerModel? customer;

  const CustomerFormPage({super.key, this.customer});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (c) =>
          CustomerFormProvider(c.read<CustomerRepository>())
            ..loadData(customer),
      child: const _CustomerFormView(),
    );
  }
}

class _CustomerFormView extends StatelessWidget {
  const _CustomerFormView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CustomerFormProvider>();
    final isEdit = provider.model != null;

    return AppLayout(
      title: isEdit ? 'Editar Cliente' : 'Novo Cliente',
      isLoading: provider.isSaving,
      body: Form(
        key: provider.formKey,
        autovalidateMode: AutovalidateMode.onUnfocus,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                isRequired: true,
                label: 'Nome',
                controller: provider.nameController,
              ),
              const SizedBox(height: 12),
              AppTextField(
                isRequired: true,
                label: 'Documento',
                controller: provider.documentController,
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: 'Email',
                controller: provider.emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: 'Telefone',
                controller: provider.phoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: 'Endereço',
                controller: provider.addressController,
              ),
              const SizedBox(height: 12),
              AppSelect<CustomerStateModel>(
                label: 'Estado',
                value: provider.selectedState,
                onChanged: (s) => provider.selectState(s),
                items: provider.states
                    .map((s) => DropdownMenuItem(value: s, child: Text(s.name)))
                    .toList(),
              ),
              const SizedBox(height: 12),
              AppSelect<CustomerCityModel>(
                label: 'Cidade',
                value: provider.selectedCity,
                onChanged: (c) => provider.selectCity(c),
                items: provider.cities
                    .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                    .toList(),
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: 'CEP',
                controller: provider.zipcodeController,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: AppButton(
        type: AppButtonType.fab,
        icon: Icons.check,
        tooltip: 'Salvar',
        onPressed: () async {
          final result = await provider.save();
          if (result == true && context.mounted) context.pop(true);
        },
      ),
    );
  }
}
