import 'package:flutter/material.dart';
import 'package:management/modules/sale/models/sale_model.dart';
import 'package:management/shared/utils/utils.dart';

class SaleListItem extends StatelessWidget {
  final SaleModel sale;
  final VoidCallback onTap;

  const SaleListItem({super.key, required this.sale, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = Utils.getSaleStatusColor(sale.status, theme);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${sale.code} - ${sale.customerName?.toUpperCase() ?? ''}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.chevron_right, size: 20, color: theme.hintColor),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  sale.status.label,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Pagamento: ${sale.paymentMethod ?? '-'} / ${sale.paymentCondition ?? '-'}',
                      style: theme.textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Data: ${Utils.dateToPtBr(sale.createdAt!)}',
                    style: theme.textTheme.bodySmall,
                  ),
                  Text(
                    'Total: R\$ ${Utils.parseToCurrency(sale.totalSale ?? 0)}',
                    style: theme.textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Produtos: R\$ ${Utils.parseToCurrency(sale.totalProducts ?? 0)}',
                    style: theme.textTheme.bodySmall,
                  ),
                  Text(_buildDiscountText(), style: theme.textTheme.bodySmall),
                ],
              ),
              if ((sale.notes ?? '').trim().isNotEmpty) ...[
                const SizedBox(height: 1),
                Text(
                  'Obs: ${sale.notes}',
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _buildDiscountText() {
    if ((sale.discountValue ?? 0) > 0) {
      return 'Desc: R\$ ${Utils.parseToCurrency(sale.discountValue!)}';
    }
    if ((sale.discountPercentage ?? 0) > 0) {
      return 'Desc: ${Utils.parseToCurrency(sale.discountPercentage!)}%';
    }
    return 'Desc: R\$ 0,00';
  }
}
