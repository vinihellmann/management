import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:management/core/components/app_button.dart';
import 'package:management/core/components/app_layout.dart';
import 'package:management/modules/product/components/product_form_fields.dart';
import 'package:management/modules/product/models/product_model.dart';
import 'package:management/modules/product/providers/product_form_provider.dart';
import 'package:management/modules/product/repositories/product_repository.dart';
import 'package:provider/provider.dart';

class ProductFormPage extends StatelessWidget {
  final ProductModel? product;

  const ProductFormPage({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) =>
          ProductFormProvider(ctx.read<ProductRepository>())..loadData(product),
      child: const _ProductFormView(),
    );
  }
}

class _ProductFormView extends StatelessWidget {
  const _ProductFormView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductFormProvider>();
    final isEdit = provider.model != null;

    return AppLayout(
      title: isEdit ? 'Editar Produto' : 'Novo Produto',
      withDrawer: false,
      body: Form(
        key: provider.formKey,
        autovalidateMode: AutovalidateMode.onUnfocus,
        child: const SingleChildScrollView(
          padding: EdgeInsets.all(12),
          child: ProductFormFields(),
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
