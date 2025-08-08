import 'package:management/core/models/base_filters.dart';
import 'package:management/modules/finance/models/finance_model.dart';

class FinanceFilters extends BaseFilters {
  String? code;
  String? customerName;
  DateTime? initialDate;
  DateTime? finalDate;
  FinanceTypeEnum? type;
  FinanceStatusEnum? status;

  @override
  void clear() {
    code = null;
    customerName = null;
    initialDate = null;
    finalDate = null;
    type = null;
    status = null;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      if (code?.isNotEmpty == true) 'code': code,
      if (customerName?.isNotEmpty == true) 'customerName': customerName,
      if (initialDate != null) 'initialDate': initialDate!.toIso8601String(),
      if (finalDate != null) 'finalDate': finalDate!.toIso8601String(),
      if (type != null) 'type': type!.name,
      if (status != null) 'status': status!.name,
    };
  }

  @override
  void update(String key, dynamic value) {
    switch (key) {
      case 'code':
        code = value?.trim();
        break;
      case 'customerName':
        customerName = value?.trim();
        break;
      case 'initialDate':
        initialDate = value;
        break;
      case 'finalDate':
        finalDate = value;
        break;
      case 'type':
        type = value;
        break;
      case 'status':
        status = value;
        break;
    }
  }
}
