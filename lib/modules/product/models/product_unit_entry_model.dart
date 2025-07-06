import 'package:flutter/material.dart';
import 'package:management/modules/product/models/product_unit_model.dart';

class ProductUnitEntryModel {
  ProductUnitModel unit;
  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController stockController;

  ProductUnitEntryModel({
    required this.unit,
    required this.nameController,
    required this.priceController,
    required this.stockController,
  });
}
