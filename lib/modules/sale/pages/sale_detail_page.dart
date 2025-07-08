import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:management/core/components/app_base_detail_page.dart';
import 'package:management/core/components/app_section_description.dart';
import 'package:management/core/constants/app_route_names.dart';
import 'package:management/core/models/base_detail_info.dart';
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
    final provider = context.watch<SaleDetailProvider>();

    return AppBaseDetailPage(
      title: 'Detalhes da Venda',
      avatarIcon: Icons.shopping_cart,
      avatarLabel: 'Venda ${sale.code ?? ''}',
      subtitle: Utils.dateToPtBr(sale.createdAt!),
      onEdit: () async {
        final result = await context.pushNamed(
          AppRouteNames.saleForm,
          extra: sale,
        );
        if (result == true && context.mounted) context.pop(true);
      },
      onDelete: () async {
        final confirmed = await Utils.showDeleteDialog(context);
        if (confirmed == true) {
          await provider.delete(sale);
          if (context.mounted) context.pop(true);
        }
      },
      details: [
        BaseDetailInfo(Icons.person, 'Cliente', sale.customerName),
        BaseDetailInfo(Icons.payment, 'Forma de Pagamento', sale.paymentMethod),
        BaseDetailInfo(
          Icons.schedule,
          'Condição de Pagamento',
          sale.paymentCondition,
        ),
        BaseDetailInfo(
          Icons.discount,
          'Desconto',
          sale.discountValue != null
              ? 'R\$ ${Utils.parseToCurrency(sale.discountValue!)} (${sale.discountPercentage?.toStringAsFixed(2)}%)'
              : 'R\$ 0,00 (0%)',
        ),
        BaseDetailInfo(
          Icons.shopping_cart_checkout,
          'Total Produtos',
          'R\$ ${Utils.parseToCurrency(sale.totalProducts!)}',
        ),
        BaseDetailInfo(
          Icons.attach_money,
          'Total da Venda',
          'R\$ ${Utils.parseToCurrency(sale.totalSale!)}',
        ),
        BaseDetailInfo(Icons.info, 'Status', sale.status.label),
        if (sale.notes?.isNotEmpty == true)
          BaseDetailInfo(Icons.notes, 'Observações', sale.notes),
      ],
      children: provider.items.isEmpty
          ? null
          : [
              Align(
                alignment: Alignment.centerLeft,
                child: const AppSectionDescription(
                  description: 'Itens da Venda',
                ),
              ),
              const SizedBox(height: 12),
              ...provider.items.map(
                (item) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primary.withAlpha(30),
                        child: Icon(
                          Icons.widgets,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          spacing: 4,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.productName?.toUpperCase() ?? '-',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Unidade: ${item.unitName!.toUpperCase()}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              'Qtd: ${Utils.parseToCurrency(item.quantity!)} | '
                              'V. Unit: R\$ ${Utils.parseToCurrency(item.unitPrice!)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              'Subtotal: R\$ ${Utils.parseToCurrency(item.subtotal!)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
    );
  }
}
