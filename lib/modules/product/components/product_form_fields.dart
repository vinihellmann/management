import 'package:flutter/material.dart';
import 'package:management/core/components/app_button.dart';
import 'package:management/core/components/app_section_description.dart';
import 'package:management/core/components/app_text_field.dart';
import 'package:management/modules/product/providers/product_form_provider.dart';
import 'package:management/shared/formatters/input_formatters.dart';
import 'package:provider/provider.dart';

class ProductFormFields extends StatelessWidget {
  const ProductFormFields({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductFormProvider>();

    return Padding(
      padding: const EdgeInsets.only(bottom: 60),
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionDescription(description: 'Dados do Produto'),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AppSectionDescription(description: 'Unidades'),
              AppButton(
                icon: Icons.add,
                text: 'Adicionar',
                type: AppButtonType.text,
                onPressed: () async => provider.addUnit(),
              ),
            ],
          ),
          ...provider.unitEntries.map((entry) {
            final index = provider.unitEntries.indexOf(entry);
            return Card(
              elevation: 2,
              margin: const EdgeInsets.all(0),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  spacing: 12,
                  children: [
                    AppTextField(
                      label: 'Nome',
                      controller: entry.nameController,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: AppTextField(
                            label: 'Valor',
                            controller: entry.priceController,
                            inputFormatters: [InputFormatters.currencyMask],
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppTextField(
                            label: 'Estoque',
                            controller: entry.stockController,
                            inputFormatters: [InputFormatters.currencyMask],
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          tooltip: 'Remover unidade',
                          onPressed: () => provider.removeUnit(index),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
