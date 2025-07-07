import 'package:flutter/material.dart';
import 'package:management/modules/sale/models/sale_item_model.dart';
import 'package:management/shared/utils/utils.dart';

class SaleFormItemTile extends StatelessWidget {
  final SaleItemModel item;
  final VoidCallback onRemove;

  const SaleFormItemTile({super.key, required this.item, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text('${item.productName ?? ''} (${item.unitName ?? ''})'),
        subtitle: Text(
          'Qtd: ${item.quantity} • Unit: R\$ ${Utils.parseToCurrency(item.unitPrice!)}',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          tooltip: 'Remover item',
          onPressed: onRemove,
        ),
      ),
    );
  }
}
