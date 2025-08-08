import 'package:flutter/material.dart';
import 'package:management/core/components/app_section_form_card.dart';
import 'package:management/modules/sale/models/sale_model.dart';
import 'package:management/modules/sale/providers/sale_form_provider.dart';
import 'package:management/shared/utils/utils.dart';
import 'package:provider/provider.dart';

class SaleFormSummaryTab extends StatelessWidget {
  const SaleFormSummaryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SaleFormProvider>();
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppFormSectionCard(
            title: 'Resumo da Venda',
            children: [
              _buildLine(
                Icons.format_list_numbered_sharp,
                'Contagem de Itens',
                '${provider.items.length}',
              ),
              _buildLine(
                Icons.shopping_cart_checkout,
                'Subtotal',
                'R\$ ${Utils.parseToCurrency(provider.totalProducts)}',
              ),
              _buildLine(
                Icons.discount,
                'Desconto',
                'R\$ ${Utils.parseToCurrency(provider.discount)}',
              ),
              const Divider(),
              _buildLine(
                Icons.attach_money,
                'Total',
                'R\$ ${Utils.parseToCurrency(provider.totalSale)}',
                bold: true,
                fontSize: 16,
              ),
            ],
          ),
          AppFormSectionCard(
            title: 'Informações do Pagamento',
            children: [
              _buildLine(Icons.payment, 'Forma', provider.paymentMethod),
              _buildLine(
                Icons.schedule,
                'Condição',
                provider.paymentCondition,
              ),
              _buildLine(Icons.info, 'Status', provider.selectedStatus.label),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLine(
    IconData icon,
    String label,
    String value, {
    bool bold = false,
    double fontSize = 14,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Text(label),
          Spacer(),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
