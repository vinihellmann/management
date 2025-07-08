import 'package:flutter/material.dart';
import 'package:management/core/components/app_button.dart';
import 'package:management/core/components/app_section_form_card.dart';
import 'package:management/core/components/app_text_field.dart';
import 'package:management/modules/product/components/product_form_unit_item.dart';
import 'package:management/modules/product/providers/product_form_provider.dart';
import 'package:provider/provider.dart';

class ProductFormFields extends StatelessWidget {
  const ProductFormFields({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductFormProvider>();

    return Padding(
      padding: const EdgeInsets.only(bottom: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppFormSectionCard(
            title: 'Dados do Produto',
            children: [
              AppTextField(
                isRequired: true,
                label: 'Descrição',
                controller: provider.nameController,
              ),
              AppTextField(
                isRequired: true,
                label: 'Código de Barras',
                controller: provider.barCodeController,
              ),
              Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: AppTextField(
                      isRequired: true,
                      label: 'Marca',
                      controller: provider.brandController,
                    ),
                  ),
                  Expanded(
                    child: AppTextField(
                      isRequired: true,
                      label: 'Grupo',
                      controller: provider.groupController,
                    ),
                  ),
                ],
              ),
            ],
          ),
          AppFormSectionCard(
            title: 'Unidades',
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Lista de Unidades',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  AppButton(
                    icon: Icons.add,
                    text: 'Nova',
                    tooltip: 'Nova unidade',
                    type: AppButtonType.outline,
                    onPressed: () async => provider.addUnit(),
                  ),
                ],
              ),
              AnimatedList(
                key: provider.unitListKey,
                initialItemCount: provider.unitEntries.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index, animation) {
                  final entry = provider.unitEntries[index];
                  return ProductFormUnitItem(
                    animation: animation,
                    index: index,
                    entry: entry,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
