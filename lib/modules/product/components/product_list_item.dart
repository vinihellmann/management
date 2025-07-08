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
    if (units.isEmpty) return;
    setState(() {
      currentUnitIndex = (currentUnitIndex + 1) % units.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final hasUnits = units.isNotEmpty;
    final currentUnit = hasUnits ? units[currentUnitIndex] : null;
    final theme = Theme.of(context);

    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${p.code} - ${p.name?.toUpperCase() ?? ''}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.chevron_right, size: 20, color: theme.hintColor),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Marca: ${p.brand ?? '-'}'),
                  Text('Grupo: ${p.group ?? '-'}'),
                ],
              ),
              if (hasUnits && currentUnit != null)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withAlpha(
                      25,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.1, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: FadeTransition(opacity: animation, child: child),
                      );
                    },
                    child: GestureDetector(
                      onTap: nextUnit,
                      child: Row(
                        key: ValueKey(currentUnit.id),
                        children: [
                          Icon(
                            Icons.swap_horiz,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${currentUnit.name?.toUpperCase() ?? ''} • Estoque: ${Utils.parseToCurrency(currentUnit.stock!)}',
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withAlpha(25),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'R\$ ${Utils.parseToCurrency(currentUnit.price!)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                const Text('Nenhuma unidade cadastrada'),
            ],
          ),
        ),
      ),
    );
  }
}
