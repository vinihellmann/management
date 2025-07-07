import 'package:flutter/material.dart';
import 'package:management/modules/sale/models/sale_model.dart';
import 'package:management/shared/utils/utils.dart';

class SaleListItem extends StatelessWidget {
  final SaleModel sale;
  final VoidCallback onTap;

  const SaleListItem({super.key, required this.sale, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: Text(
            '${sale.code} - ${sale.customerName}'.toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Data: ${Utils.dateToPtBr(sale.createdAt!)}',
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Total: R\$${Utils.parseToCurrency(sale.totalSale!)}',
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ],
          ),
          onTap: onTap,
        ),
      ],
    );
  }
}
