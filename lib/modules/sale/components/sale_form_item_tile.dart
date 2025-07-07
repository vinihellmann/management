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
    return GestureDetector(
      onTap: () async {
        final productModel = await repository.getProductById(item.productId!);
        if (!context.mounted) return;

        final editedItem = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                SaleFormEditItemPage(product: productModel, saleItem: item),
          ),
        );

        if (editedItem is SaleItemModel && context.mounted) {
          context.read<SaleFormProvider>().updateItem(editedItem);
        }
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          title: Text('${item.productName} (${item.unitName})'.toUpperCase()),
          subtitle: Text(
            'Qtd: ${item.quantity} • Unit: R\$ ${Utils.parseToCurrency(item.unitPrice!)}',
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Remover item',
            onPressed: onRemove,
          ),
        ),
      ),
    );
  }
}
