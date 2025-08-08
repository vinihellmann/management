import 'package:management/core/models/base_model.dart';

class ProductUnitModel extends BaseModel {
  int? productId;
  String? name;
  double? price;
  int? stock;
  bool isDefault;

  ProductUnitModel({
    super.id,
    super.code,
    super.createdAt,
    super.updatedAt,
    this.productId,
    this.name,
    this.price,
    this.stock,
    this.isDefault = false,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'productId': productId,
      'name': name,
      'price': price,
      'stock': stock,
      'isDefault': isDefault ? 1 : 0,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  ProductUnitModel fromMap(Map<String, dynamic> map) {
    return ProductUnitModel(
      id: map['id'],
      code: map['code'],
      productId: map['productId'],
      name: map['name'],
      price: (map['price'] as num?)?.toDouble(),
      stock: (map['stock'] as num?)?.toInt(),
      isDefault: map['isDefault'] == 1,
      createdAt: DateTime.tryParse(map['createdAt']),
      updatedAt: DateTime.tryParse(map['updatedAt']),
    );
  }

  ProductUnitModel copyWith({
    int? id,
    String? code,
    String? name,
    double? price,
    int? stock,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductUnitModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
