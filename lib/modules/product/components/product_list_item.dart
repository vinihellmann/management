import 'package:flutter/material.dart';
import 'package:management/modules/product/models/product_model.dart';
import 'package:management/modules/product/models/product_unit_model.dart';
import 'package:management/shared/utils/utils.dart';

class ProductListItem extends StatefulWidget {
  final ProductModel product;
  final VoidCallback onTap;

  const ProductListItem({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  State<ProductListItem> createState() => _ProductListItemState();
}

class _ProductListItemState extends State<ProductListItem> {
  late int currentUnitIndex;

  List<ProductUnitModel> get units => widget.product.units;

  @override
  void initState() {
    super.initState();
    currentUnitIndex = 0;
  }

  void nextUnit() {
    setState(() {
      currentUnitIndex = (currentUnitIndex + 1) % units.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final hasUnits = units.isNotEmpty;
    final currentUnit = hasUnits ? units[currentUnitIndex] : null;

    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: Text(
            '${p.code} - ${p.name}'.toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text('Marca: ${p.brand}')),
                  Expanded(
                    child: Text('Grupo: ${p.group}', textAlign: TextAlign.end),
                  ),
                ],
              ),
              if (hasUnits && currentUnit != null)
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) {
                    final offsetAnimation = Tween<Offset>(
                      begin: const Offset(0.2, 0),
                      end: Offset.zero,
                    ).animate(animation);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                  child: Row(
                    key: ValueKey(currentUnit.name),
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Estoque: ${Utils.parseToCurrency(currentUnit.stock!)} ${currentUnit.name!.toUpperCase()}',
                        ),
                      ),
                      IconButton(
                        onPressed: nextUnit,
                        icon: Icon(
                          size: 20,
                          Icons.swap_horiz,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Preço: R\$ ${Utils.parseToCurrency(currentUnit.price!)}',
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                )
              else
                const SizedBox(height: 12),
            ],
          ),
          onTap: widget.onTap,
        ),
      ],
    );
  }
}
