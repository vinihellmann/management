import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:management/core/components/app_button.dart';
import 'package:management/core/components/app_section_description.dart';
import 'package:management/core/constants/app_route_names.dart';
import 'package:management/modules/product/models/product_model.dart';
import 'package:management/modules/sale/components/sale_form_item_tile.dart';
import 'package:management/modules/sale/models/sale_item_model.dart';
import 'package:management/modules/sale/providers/sale_form_provider.dart';
import 'package:management/shared/utils/utils.dart';
import 'package:provider/provider.dart';

class SaleFormItemsTab extends StatelessWidget {
  const SaleFormItemsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SaleFormProvider>();
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        spacing: 12,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AppSectionDescription(description: 'Itens da Venda'),
              AppButton(
                icon: Icons.add,
                text: 'Adicionar',
                type: AppButtonType.text,
                onPressed: () => onSelectProduct(context),
              ),
            ],
          ),
          if (provider.items.isEmpty)
            const Center(child: Text('Nenhum item adicionado.'))
          else
            Expanded(
              child: ListView.separated(
                itemCount: provider.items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = provider.items[index];
                  return SaleFormItemTile(
                    item: item,
                    onRemove: () => onRemoveItem(context, item),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Future<void> onRemoveItem(BuildContext context, SaleItemModel item) async {
    final result = await Utils.showDeleteDialog(context);

    if (result == true && context.mounted) {
      context.read<SaleFormProvider>().removeItem(item);
    }
  }

  Future<void> onSelectProduct(BuildContext context) async {
    final product = await context.pushNamed(AppRouteNames.productSelect);
    if (product is! ProductModel || !context.mounted) return;

    final item = await context.pushNamed(
      AppRouteNames.saleFormEditItem,
      extra: product,
    );

    if (item is SaleItemModel && context.mounted) {
      context.read<SaleFormProvider>().addItem(item);
    }
  }
}
