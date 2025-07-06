import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:management/core/components/app_button.dart';
import 'package:management/core/components/app_layout.dart';
import 'package:management/core/services/app_zip_service.dart';
import 'package:management/modules/customer/components/customer_form_fields.dart';
import 'package:management/modules/customer/models/customer_model.dart';
import 'package:management/modules/customer/providers/customer_form_provider.dart';
import 'package:management/modules/customer/repositories/customer_repository.dart';
import 'package:provider/provider.dart';

class CustomerFormPage extends StatelessWidget {
  final CustomerModel? customer;

  const CustomerFormPage({super.key, this.customer});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => AppZipService()),
        ChangeNotifierProvider(
          create: (c) => CustomerFormProvider(
            c.read<CustomerRepository>(),
            c.read<AppZipService>(),
          )..loadData(customer),
        ),
      ],
      child: _CustomerFormView(),
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
      withDrawer: false,
      body: Form(
        key: provider.formKey,
        autovalidateMode: AutovalidateMode.onUnfocus,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(12),
          child: CustomerFormFields(),
        ),
      ),
      floatingActionButton: AppButton(
        isLoading: provider.isSaving,
        type: AppButtonType.filled,
        text: 'Salvar',
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
