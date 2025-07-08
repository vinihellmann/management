import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:management/core/components/app_button.dart';
import 'package:management/core/components/app_layout.dart';
import 'package:management/core/constants/app_route_names.dart';
import 'package:management/core/themes/app_colors.dart';
import 'package:management/modules/sale/models/sale_model.dart';
import 'package:management/modules/sale/models/sale_status_enum.dart';
import 'package:management/modules/sale/providers/sale_detail_provider.dart';
import 'package:management/shared/utils/utils.dart';
import 'package:provider/provider.dart';

class SaleDetailPage extends StatelessWidget {
  final SaleModel sale;

  const SaleDetailPage({super.key, required this.sale});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => SaleDetailProvider(ctx.read())..loadItems(sale.items),
      child: _SaleDetailView(sale),
    );
  }
}

class _SaleDetailView extends StatelessWidget {
  final SaleModel sale;

  const _SaleDetailView(this.sale);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<SaleDetailProvider>();

    return AppLayout(
      title: 'Detalhes da Venda',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: const Icon(
                          Icons.receipt_long,
                          color: AppColors.primary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Venda ${sale.code}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              sale.customerName ?? '',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  _buildInfoRow(
                    Icons.payment,
                    'Forma de Pagamento',
                    sale.paymentMethod,
                  ),
                  _buildInfoRow(
                    Icons.schedule,
                    'Condição de Pagamento',
                    sale.paymentCondition,
                  ),
                  _buildInfoRow(Icons.info, 'Status', sale.status.label),
                  _buildInfoRow(
                    Icons.shopping_cart,
                    'Total Produtos',
                    'R\$ ${Utils.parseToCurrency(sale.totalProducts ?? 0)}',
                  ),
                  _buildInfoRow(
                    Icons.discount,
                    'Desconto',
                    sale.discountValue != null
                        ? 'R\$ ${Utils.parseToCurrency(sale.discountValue!)} (${sale.discountPercentage?.toStringAsFixed(2)}%)'
                        : 'R\$ 0,00 (0%)',
                  ),
                  _buildInfoRow(
                    Icons.attach_money,
                    'Total da Venda',
                    'R\$ ${Utils.parseToCurrency(sale.totalSale ?? 0)}',
                  ),
                  if (sale.notes?.isNotEmpty == true)
                    _buildInfoRow(Icons.notes, 'Observações', sale.notes),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (provider.items.isNotEmpty)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Itens da Venda',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...provider.items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.widgets,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.productName ?? '-',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Unidade: ${item.unitName ?? ''}\n'
                                    'Qtd: ${item.quantity} | '
                                    'V. Unit: R\$ ${Utils.parseToCurrency(item.unitPrice ?? 0)}\n'
                                    'Subtotal: R\$ ${Utils.parseToCurrency(item.subtotal ?? 0)}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 160),
          ],
        ),
      ),
      floatingActionButton: Column(
        spacing: 24,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AppButton(
            type: AppButtonType.remove,
            onPressed: () async {
              final confirmed = await Utils.showDeleteDialog(context);
              if (confirmed == true) {
                await provider.delete(sale);
                if (context.mounted) context.pop(true);
              }
            },
          ),
          AppButton(
            type: AppButtonType.edit,
            onPressed: () async {
              final result = await context.pushNamed(
                AppRouteNames.saleForm,
                extra: sale,
              );
              if (result == true && context.mounted) context.pop(true);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(value ?? '-', style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
