import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:management/core/components/app_button.dart';
import 'package:management/core/components/app_detail_info_card.dart';
import 'package:management/core/components/app_layout.dart';
import 'package:management/core/components/app_section_description.dart';
import 'package:management/core/constants/app_route_names.dart';
import 'package:management/core/themes/app_colors.dart';
import 'package:management/modules/product/models/product_model.dart';
import 'package:management/modules/product/providers/product_detail_provider.dart';
import 'package:management/shared/utils/utils.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductModel product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) =>
          ProductDetailProvider(ctx.read())..loadUnits(product.id!),
      child: _ProductDetailView(product),
    );
  }
}

class _ProductDetailView extends StatelessWidget {
  final ProductModel product;

  const _ProductDetailView(this.product);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductDetailProvider>();

    return AppLayout(
      withDrawer: false,
      title: 'Detalhes do Produto',
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
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
                  value: product.code ?? '',
                  icon: Icons.qr_code,
                  color: AppColors.primary,
                ),
                AppDetailInfoCard(
                  width: double.infinity,
                  title: 'Nome',
                  value: product.name ?? '',
                  icon: Icons.inventory_2,
                  color: AppColors.primary,
                ),
                AppDetailInfoCard(
                  width: double.infinity,
                  title: 'Código de Barras',
                  value: product.barCode ?? '',
                  icon: Icons.qr_code_2,
                  color: AppColors.primary,
                ),
                AppDetailInfoCard(
                  width: double.infinity,
                  title: 'Marca',
                  value: product.brand ?? '',
                  icon: Icons.flag,
                  color: AppColors.primary,
                ),
                AppDetailInfoCard(
                  width: double.infinity,
                  title: 'Grupo',
                  value: product.group ?? '',
                  icon: Icons.category,
                  color: AppColors.primary,
                ),
              ],
            ),
            if (provider.units.isNotEmpty) ...[
              AppSectionDescription(description: 'Unidades'),
              ...provider.units.map(
                (u) => ListTile(
                  leading: const Icon(Icons.widgets),
                  title: Text(u.name!),
                  subtitle: Text(
                    'Valor: R\$ ${Utils.parseToCurrency(u.price!)}\nEstoque: ${Utils.parseToCurrency(u.stock!)}',
                  ),
                ),
              ),
              SizedBox(height: 120),
            ],
          ],
        ),
      ),
      floatingActionButton: Column(
        spacing: 12,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AppButton(
            tooltip: 'Excluir',
            icon: Icons.delete,
            color: Theme.of(context).colorScheme.error,
            type: AppButtonType.fab,
            onPressed: () async {
              final confirmed = await Utils.showDeleteDialog(context);

              if (confirmed == true) {
                await provider.delete(product);
                if (context.mounted) context.pop(true);
              }
            },
          ),
          AppButton(
            tooltip: 'Editar',
            icon: Icons.edit,
            text: 'Editar',
            color: AppColors.secondary,
            type: AppButtonType.filled,
            onPressed: () async {
              final result = await context.pushNamed(
                AppRouteNames.productForm,
                extra: product,
              );

              if (result == true && context.mounted) context.pop(true);
            },
          ),
        ],
      ),
    );
  }
}
