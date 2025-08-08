import 'package:flutter/material.dart';
import 'package:management/core/models/base_model.dart';
import 'package:management/core/themes/app_colors.dart';

enum FinanceTypeEnum { receivable, payable }

enum FinanceStatusEnum { pending, confirmed, canceled }

extension FinanceTypeEnumExtension on FinanceTypeEnum {
  String get label {
    switch (this) {
      case FinanceTypeEnum.receivable:
        return 'A Receber';
      case FinanceTypeEnum.payable:
        return 'A Pagar';
    }
  }

  Color get color {
    switch (this) {
      case FinanceTypeEnum.receivable:
        return AppColors.tertiary;
      case FinanceTypeEnum.payable:
        return AppColors.darkError;
    }
  }

  IconData get icon {
    switch (this) {
      case FinanceTypeEnum.receivable:
        return Icons.arrow_upward;
      case FinanceTypeEnum.payable:
        return Icons.arrow_downward;
    }
  }
}

extension FinanceStatusEnumExtension on FinanceStatusEnum {
  String get label {
    switch (this) {
      case FinanceStatusEnum.pending:
        return 'Pendente';
      case FinanceStatusEnum.confirmed:
        return 'Confirmado';
      case FinanceStatusEnum.canceled:
        return 'Cancelado';
    }
  }
}

class FinanceModel extends BaseModel {
  String? saleCode;
  int? customerId;
  String? customerName;
  double? value;
  DateTime? dueDate;
  FinanceTypeEnum type;
  FinanceStatusEnum status;
  String? notes;

  FinanceModel({
    super.id,
    super.code,
    super.createdAt,
    super.updatedAt,
    this.saleCode,
    this.customerId,
    this.customerName,
    this.value,
    this.dueDate,
    this.notes,
    this.type = FinanceTypeEnum.receivable,
    this.status = FinanceStatusEnum.pending,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'saleCode': saleCode,
      'customerId': customerId,
      'customerName': customerName,
      'value': value,
      'dueDate': dueDate?.toIso8601String(),
      'notes': notes,
      'type': type.name,
      'status': status.name,
    };
  }

  @override
  FinanceModel fromMap(Map<String, dynamic> map) {
    return FinanceModel(
      id: map['id'] as int?,
      code: map['code'] as String?,
      createdAt: DateTime.tryParse(map['createdAt'] ?? ''),
      updatedAt: DateTime.tryParse(map['updatedAt'] ?? ''),
      saleCode: map['saleCode'] as String?,
      customerId: map['customerId'] as int?,
      customerName: map['customerName'] as String?,
      value: (map['value'] as num?)?.toDouble(),
      dueDate: DateTime.tryParse(map['dueDate'] ?? ''),
      notes: map['notes'] as String?,
      type: FinanceTypeEnum.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => FinanceTypeEnum.receivable,
      ),
      status: FinanceStatusEnum.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => FinanceStatusEnum.pending,
      ),
    );
  }
}
