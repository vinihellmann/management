import 'package:flutter/material.dart';
import 'package:management/core/components/app_text_field.dart';
import 'package:management/modules/product/models/product_unit_entry_model.dart';
import 'package:management/modules/product/providers/product_form_provider.dart';
import 'package:management/shared/formatters/input_formatters.dart';
import 'package:management/shared/utils/utils.dart';
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
              Row(
                children: [
                  Text(
                    'Unidade ${index + 1}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    tooltip: 'Remover unidade',
                    onPressed: () => _showDeleteDialog(context),
                  ),
                  IconButton(
                    icon: Icon(
                      entry.unit.isDefault ? Icons.star : Icons.star_border,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    tooltip: 'Marcar como padrão',
                    onPressed: () {
                      provider.setDefaultUnitByEntry(entry);
                    },
                  ),
                ],
              ),
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context) async {
    final provider = context.read<ProductFormProvider>();
    final result = await Utils.showDeleteDialog(context);
    if (result == true) provider.removeUnit(index);
  }
}
