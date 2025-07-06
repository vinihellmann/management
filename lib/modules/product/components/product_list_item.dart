import 'package:flutter/material.dart';
import 'package:management/modules/product/models/product_model.dart';

class ProductListItem extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;

  const ProductListItem({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text(product.name![0].toUpperCase())),
      title: Text('${product.code} - ${product.name}'),
      subtitle: Text('Marca: ${product.brand}\nGrupo: ${product.group}'),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
