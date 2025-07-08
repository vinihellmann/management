import 'package:flutter/material.dart';
import 'package:management/modules/sale/models/sale_item_model.dart';
import 'package:management/modules/sale/pages/sale_form_edit_item_page.dart';
import 'package:management/modules/sale/providers/sale_form_provider.dart';
import 'package:management/modules/sale/repositories/sale_repository.dart';
import 'package:management/shared/utils/utils.dart';
import 'package:provider/provider.dart';

class SaleFormItemTile extends StatelessWidget {
  final SaleItemModel item;
  final VoidCallback onRemove;

  const SaleFormItemTile({
    super.key,
    required this.item,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final repository = context.read<SaleRepository>();
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () async {
        final product = await repository.getProductById(item.productId!);
        if (!context.mounted) return;

        final editedItem = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                SaleFormEditItemPage(product: product, saleItem: item),
          ),
        );

        if (editedItem is SaleItemModel && context.mounted) {
          context.read<SaleFormProvider>().updateItem(editedItem);
        }
      },
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${item.productName?.toUpperCase()} (${item.unitName})',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: onRemove,
                    icon: Icon(
                      Icons.delete_outline,
                      color: theme.colorScheme.error,
                    ),
                    tooltip: 'Remover item',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Qtd: ${Utils.parseToCurrency(item.quantity ?? 0)}',
                    style: theme.textTheme.bodySmall,
                  ),
                  Text(
                    'Unitário: R\$${Utils.parseToCurrency(item.unitPrice ?? 0)}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  'Subtotal: R\$${Utils.parseToCurrency(item.subtotal ?? 0)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
