import 'package:management/core/models/base_model.dart';
import 'package:management/modules/product/models/product_unit_model.dart';

class ProductModel extends BaseModel {
  String? barCode;
  String? name;
  String? brand;
  String? group;
  String? description;
  List<ProductUnitModel> units;

  ProductModel({
    super.id,
    super.code,
    super.createdAt,
    super.updatedAt,
    this.barCode,
    this.name,
    this.brand,
    this.group,
    this.description,
    this.units = const [],
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'barCode': barCode,
      'name': name,
      'brand': brand,
      'group': group,
      'description': description,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  ProductModel fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      code: map['code'],
      barCode: map['barCode'],
      name: map['name'],
      brand: map['brand'],
      group: map['group'],
      description: map['description'],
      createdAt: DateTime.tryParse(map['createdAt']),
      updatedAt: DateTime.tryParse(map['updatedAt']),
    );
  }
}
