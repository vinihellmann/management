import 'package:management/core/models/base_model.dart';

class SaleItemModel extends BaseModel {
  int? saleId;
  int? productId;
  String? productName;
  int? unitId;
  String? unitName;
  double? quantity;
  double? unitPrice;
  double? subtotal;

  SaleItemModel({
    super.id,
    super.code,
    super.createdAt,
    super.updatedAt,
    this.saleId,
    this.productId,
    this.productName,
    this.unitId,
    this.unitName,
    this.quantity,
    this.unitPrice,
    this.subtotal,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'saleId': saleId,
      'productId': productId,
      'productName': productName,
      'unitId': unitId,
      'unitName': unitName,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'subtotal': subtotal,
    };
  }

  @override
  SaleItemModel fromMap(Map<String, dynamic> map) {
    return SaleItemModel(
      id: map['id'] as int?,
      code: map['code'] as String?,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      saleId: map['saleId'] as int?,
      productId: map['productId'] as int?,
      productName: map['productName'] as String?,
      unitId: map['unitId'] as int?,
      unitName: map['unitName'] as String?,
      quantity: (map['quantity'] as num?)?.toDouble(),
      unitPrice: (map['unitPrice'] as num?)?.toDouble(),
      subtotal: (map['subtotal'] as num?)?.toDouble(),
    );
  }
}
