import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:management/core/components/app_button.dart';
import 'package:management/core/components/app_layout.dart';
import 'package:management/modules/product/models/product_model.dart';
import 'package:management/modules/sale/models/sale_item_model.dart';
import 'package:management/shared/formatters/input_formatters.dart'; // <- certifique-se de importar
import 'package:management/shared/utils/utils.dart';

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

  double subtotal = 0.0;

  List get units => widget.product?.units ?? [];
  String get name => widget.saleItem?.productName ?? widget.product?.name ?? '';
  String get code => widget.product?.code ?? '';
  int? get productId => widget.saleItem?.productId ?? widget.product?.id;

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
      text: Utils.parseToCurrency(initialPrice),
    );
    quantityController = TextEditingController(
      text: Utils.parseToCurrency(initialQuantity),
    );

    priceController.addListener(calculateSubtotal);
    quantityController.addListener(calculateSubtotal);

    calculateSubtotal();
  }

  void nextUnit() {
    if (units.isEmpty) return;
    setState(() {
      currentUnitIndex = (currentUnitIndex + 1) % units.length;
      priceController.text = Utils.parseToCurrency(
        units[currentUnitIndex].price ?? 0,
      )!;
    });
  }

  void calculateSubtotal() {
    final price = Utils.parseToDouble(priceController.text)!;
    final quantity = Utils.parseToDouble(quantityController.text)!;
    setState(() {
      subtotal = price * quantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUnit = units.isNotEmpty ? units[currentUnitIndex] : null;
    final theme = Theme.of(context);

    return AppLayout(
      withDrawer: false,
      title: widget.saleItem != null ? 'Editar Item' : 'Adicionar Produto',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              spacing: 24,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$code - $name'.toUpperCase(),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (currentUnit != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Unidade: ${currentUnit.name.toUpperCase()}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      IconButton(
                        onPressed: nextUnit,
                        icon: const Icon(Icons.swap_horiz),
                        tooltip: 'Alterar unidade',
                      ),
                    ],
                  ),
                TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [InputFormatters.currencyMask],
                  decoration: const InputDecoration(
                    labelText: 'Valor Unitário (R\$)',
                    prefixIcon: Icon(Icons.attach_money_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                TextFormField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [InputFormatters.currencyMask],
                  decoration: const InputDecoration(
                    labelText: 'Quantidade',
                    prefixIcon: Icon(Icons.confirmation_number_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Subtotal:',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      'R\$ ${Utils.parseToCurrency(subtotal)}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: AppButton(
        type: AppButtonType.save,
        onPressed: () async {
          final price = Utils.parseToDouble(priceController.text);
          final quantity = Utils.parseToDouble(quantityController.text);
          final subtotal = price! * quantity!;

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
    );
  }

  @override
  void dispose() {
    priceController.removeListener(calculateSubtotal);
    quantityController.removeListener(calculateSubtotal);
    priceController.dispose();
    quantityController.dispose();
    super.dispose();
  }
}
