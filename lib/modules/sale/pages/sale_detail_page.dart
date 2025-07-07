import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:management/core/components/app_button.dart';
import 'package:management/core/components/app_detail_info_card.dart';
import 'package:management/core/components/app_layout.dart';
import 'package:management/core/components/app_section_description.dart';
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
    final provider = context.watch<SaleDetailProvider>();

    return AppLayout(
      withDrawer: false,
      title: 'Detalhes da Venda',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 24,
              runSpacing: 24,
              children: [
                AppDetailInfoCard(
                  width: double.infinity,
                  title: 'Código',
                  value: sale.code ?? '',
                  icon: Icons.confirmation_number,
                  color: AppColors.primary,
                ),
                AppDetailInfoCard(
                  width: double.infinity,
                  title: 'Cliente',
                  value: sale.customerName ?? '',
                  icon: Icons.person,
                  color: AppColors.primary,
                ),
                AppDetailInfoCard(
                  width: double.infinity,
                  title: 'Forma de Pagamento',
                  value: sale.paymentMethod ?? '',
                  icon: Icons.payment,
                  color: AppColors.primary,
                ),
                AppDetailInfoCard(
                  width: double.infinity,
                  title: 'Condição de Pagamento',
                  value: sale.paymentCondition ?? '',
                  icon: Icons.schedule,
                  color: AppColors.primary,
                ),
                AppDetailInfoCard(
                  width: double.infinity,
                  title: 'Status',
                  value: sale.status.label,
                  icon: Icons.info,
                  color: AppColors.primary,
                ),
                AppDetailInfoCard(
                  width: double.infinity,
                  title: 'Total Produtos',
                  value: 'R\$ ${Utils.parseToCurrency(sale.totalProducts!)}',
                  icon: Icons.shopping_cart,
                  color: AppColors.primary,
                ),
                AppDetailInfoCard(
                  width: double.infinity,
                  title: 'Desconto',
                  value: sale.discountValue != null
                      ? 'R\$ ${Utils.parseToCurrency(sale.discountValue!)} (${sale.discountPercentage?.toStringAsFixed(2)}%)'
                      : 'R\$ 0,00 (0%)',
                  icon: Icons.discount,
                  color: AppColors.primary,
                ),
                AppDetailInfoCard(
                  width: double.infinity,
                  title: 'Total da Venda',
                  value: 'R\$ ${Utils.parseToCurrency(sale.totalSale!)}',
                  icon: Icons.attach_money,
                  color: AppColors.primary,
                ),
                if (sale.notes?.isNotEmpty == true)
                  AppDetailInfoCard(
                    width: double.infinity,
                    title: 'Observações',
                    value: sale.notes!,
                    icon: Icons.notes,
                    color: AppColors.primary,
                  ),
              ],
            ),
            if (provider.items.isNotEmpty) ...[
              const AppSectionDescription(description: 'Itens da Venda'),
              ...provider.items.map(
                (item) => ListTile(
                  leading: const Icon(Icons.widgets),
                  title: Text(item.productName ?? ''),
                  subtitle: Text(
                    'Unidade: ${item.unitName ?? ''}\n'
                    'Qtd: ${item.quantity} | '
                    'V. Unit: R\$ ${Utils.parseToCurrency(item.unitPrice!)}\n'
                    'Subtotal: R\$ ${Utils.parseToCurrency(item.subtotal!)}',
                  ),
                ),
              ),
              const SizedBox(height: 140),
            ],
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
}
