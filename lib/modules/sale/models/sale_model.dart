import 'package:management/core/models/base_model.dart';
import 'package:management/modules/sale/models/sale_item_model.dart';
import 'package:management/modules/sale/models/sale_status_enum.dart';

class SaleModel extends BaseModel {
  int? customerId;
  String? customerName;
  String? paymentMethod;
  String? paymentCondition;
  double? discountValue;
  double? discountPercentage;
  double? totalProducts;
  double? totalSale;
  SaleStatusEnum status;

  List<SaleItemModel> items;

  SaleModel({
    super.id,
    super.code,
    super.createdAt,
    super.updatedAt,
    this.customerId,
    this.customerName,
    this.paymentMethod,
    this.paymentCondition,
    this.discountValue,
    this.discountPercentage,
    this.totalProducts,
    this.totalSale,
    this.status = SaleStatusEnum.open,
    this.items = const [],
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'customerId': customerId,
      'customerName': customerName,
      'paymentMethod': paymentMethod,
      'paymentCondition': paymentCondition,
      'discountValue': discountValue,
      'discountPercentage': discountPercentage,
      'totalProducts': totalProducts,
      'totalSale': totalSale,
      'status': status.name,
    };
  }

  @override
  SaleModel fromMap(Map<String, dynamic> map) {
    return SaleModel(
      id: map['id'] as int?,
      code: map['code'] as String?,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      customerId: map['customerId'] as int?,
      customerName: map['customerName'] as String?,
      paymentMethod: map['paymentMethod'] as String?,
      paymentCondition: map['paymentCondition'] as String?,
      discountValue: (map['discountValue'] as num?)?.toDouble(),
      discountPercentage: (map['discountPercentage'] as num?)?.toDouble(),
      totalProducts: (map['totalProducts'] as num?)?.toDouble(),
      totalSale: (map['totalSale'] as num?)?.toDouble(),
      status: SaleStatusEnum.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => SaleStatusEnum.open,
      ),
    );
  }
}
