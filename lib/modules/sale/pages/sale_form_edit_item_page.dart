import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:management/core/components/app_button.dart';
import 'package:management/core/components/app_layout.dart';
import 'package:management/modules/product/models/product_model.dart';
import 'package:management/modules/sale/models/sale_item_model.dart';

class SaleFormEditItemPage extends StatefulWidget {
  final ProductModel product;

  const SaleFormEditItemPage({super.key, required this.product});

  @override
  State<SaleFormEditItemPage> createState() => _SaleFormEditItemPageState();
}

class _SaleFormEditItemPageState extends State<SaleFormEditItemPage> {
  late TextEditingController priceController;
  late TextEditingController quantityController;

  @override
  void initState() {
    super.initState();
    priceController = TextEditingController(
      text: widget.product.units.first.price?.toStringAsFixed(2) ?? '0.00',
    );
    quantityController = TextEditingController(text: '1');
  }

  @override
  Widget build(BuildContext context) {
    final unit = widget.product.units.first;

    return AppLayout(
      title: 'Adicionar Produto',
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              widget.product.name ?? '',
              style: Theme.of(context).textTheme.titleLarge,
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

                final item = SaleItemModel(
                  productId: widget.product.id,
                  productName: widget.product.name,
                  unitId: unit.id,
                  unitName: unit.name,
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

  @override
  void dispose() {
    priceController.dispose();
    quantityController.dispose();
    super.dispose();
  }
}
