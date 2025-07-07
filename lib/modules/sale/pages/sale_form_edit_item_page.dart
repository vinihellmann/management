import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:management/core/components/app_button.dart';
import 'package:management/core/components/app_layout.dart';
import 'package:management/modules/product/models/product_model.dart';
import 'package:management/modules/sale/models/sale_item_model.dart';

class SaleFormEditItemPage extends StatefulWidget {
  final ProductModel? product;
  final SaleItemModel? saleItem;

  const SaleFormEditItemPage({super.key, this.product, this.saleItem});

  @override
  State<SaleFormEditItemPage> createState() => _SaleFormEditItemPageState();
}

class _SaleFormEditItemPageState extends State<SaleFormEditItemPage> {
  late TextEditingController priceController;
  late TextEditingController quantityController;
  late int currentUnitIndex;

  List get units => widget.product?.units ?? [];

  @override
  void initState() {
    super.initState();

    if (widget.saleItem != null && units.isNotEmpty) {
      final index = units.indexWhere((u) => u.id == widget.saleItem!.unitId);
      currentUnitIndex = index != -1 ? index : 0;
    } else {
      currentUnitIndex = 0;
    }

    final initialPrice =
        widget.saleItem?.unitPrice ?? units[currentUnitIndex].price ?? 0.0;
    final initialQuantity = widget.saleItem?.quantity ?? 1.0;

    priceController = TextEditingController(
      text: initialPrice.toStringAsFixed(2),
    );
    quantityController = TextEditingController(
      text: initialQuantity.toString(),
    );
  }

  void nextUnit() {
    if (units.isEmpty) return;
    setState(() {
      currentUnitIndex = (currentUnitIndex + 1) % units.length;
      priceController.text =
          units[currentUnitIndex].price?.toStringAsFixed(2) ?? '0.00';
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUnit = units.isNotEmpty ? units[currentUnitIndex] : null;

    return AppLayout(
      title: widget.saleItem != null ? 'Editar Item' : 'Adicionar Produto',
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            if (currentUnit != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Unidade: ${currentUnit.name}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  IconButton(
                    onPressed: nextUnit,
                    icon: const Icon(Icons.swap_horiz),
                    tooltip: 'Alterar unidade',
                  ),
                ],
              ),
            const SizedBox(height: 16),
            TextFormField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Valor Unitário (R\$)',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Quantidade'),
            ),
            const SizedBox(height: 24),
            AppButton(
              text: 'Confirmar',
              onPressed: () async {
                final price = double.tryParse(priceController.text) ?? 0;
                final quantity = double.tryParse(quantityController.text) ?? 0;
                final subtotal = price * quantity;

                final unit = currentUnit;

                final item = SaleItemModel(
                  id: widget.saleItem?.id,
                  productId: productId,
                  productName: name,
                  unitId: unit?.id,
                  unitName: unit?.name,
                  unitPrice: price,
                  quantity: quantity,
                  subtotal: subtotal,
                );

                context.pop(item);
              },
            ),
          ],
        ),
      ),
    );
  }

  String get name => widget.saleItem?.productName ?? widget.product?.name ?? '';

  int? get productId => widget.saleItem?.productId ?? widget.product?.id;

  @override
  void dispose() {
    priceController.dispose();
    quantityController.dispose();
    super.dispose();
  }
}
