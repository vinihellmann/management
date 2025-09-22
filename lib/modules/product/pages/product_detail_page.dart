import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:management/core/components/app_base_detail_page.dart';
import 'package:management/core/components/app_section_description.dart';
import 'package:management/core/constants/app_route_names.dart';
import 'package:management/core/extensions/extensions.dart';
import 'package:management/core/models/base_detail_info.dart';
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
          ProductDetailProvider(ctx.read())..loadUnits(product.units),
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

    return AppBaseDetailPage(
      title: 'Detalhes do Produto',
      avatarIcon: Icons.inventory_2,
      avatarLabel: '${product.name?.toUpperCase()}',
      subtitle: 'Código: ${product.code}',
      onEdit: () async {
        final result = await context.pushNamed(
          AppRouteNames.productForm,
          extra: product,
        );
        if (result == true && context.mounted) context.pop(true);
      },
      onDelete: () async {
        if (!context.isManager) return;

        final confirmed = await Utils.showDeleteDialog(context);
        if (confirmed == true) {
          await provider.delete(product);
          if (context.mounted) context.pop(true);
        }
      },
      details: [
        BaseDetailInfo(Icons.qr_code_2, 'Código de Barras', product.barCode),
        BaseDetailInfo(Icons.flag, 'Marca', product.brand),
        BaseDetailInfo(Icons.category, 'Grupo', product.group),
      ],
      children: provider.units.isEmpty
          ? null
          : [
              Align(
                alignment: Alignment.centerLeft,
                child: AppSectionDescription(description: 'Unidades'),
              ),
              const SizedBox(height: 12),
              ...provider.units.map(
                (u) => Container(
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
                        ).colorScheme.primary.withAlpha(40),
                        child: Icon(
                          Icons.widgets,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              u.name?.toUpperCase() ?? '-',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Valor: R\$ ${Utils.parseToCurrency(u.price!)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              'Estoque: ${u.stock}',
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
