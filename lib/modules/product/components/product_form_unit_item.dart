import 'package:flutter/material.dart';
import 'package:management/core/components/app_text_field.dart';
import 'package:management/modules/product/models/product_unit_entry_model.dart';
import 'package:management/modules/product/providers/product_form_provider.dart';
import 'package:management/shared/formatters/input_formatters.dart';
import 'package:provider/provider.dart';

class ProductFormUnitItem extends StatelessWidget {
  const ProductFormUnitItem({
    super.key,
    required this.animation,
    required this.index,
    required this.entry,
  });

  final int index;
  final Animation<double> animation;
  final ProductUnitEntryModel entry;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductFormProvider>();
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            spacing: 12,
            children: [
              AppTextField(
                isRequired: true,
                label: 'Nome',
                controller: entry.nameController,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: AppTextField(
                      isRequired: true,
                      label: 'Valor',
                      controller: entry.priceController,
                      inputFormatters: [InputFormatters.currencyMask],
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppTextField(
                      isRequired: true,
                      label: 'Estoque',
                      controller: entry.stockController,
                      inputFormatters: [InputFormatters.currencyMask],
                      keyboardType: TextInputType.number,
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
      ),
    );
  }
}
