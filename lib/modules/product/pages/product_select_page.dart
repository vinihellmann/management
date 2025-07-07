import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:management/modules/product/pages/product_list_page.dart';

class ProductSelectPage extends StatelessWidget {
  const ProductSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ProductListPage(
      onSelect: (product) {
        context.pop(product);
      },
    );
  }
}
