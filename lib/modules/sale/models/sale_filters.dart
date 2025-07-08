import 'package:management/core/models/base_filters.dart';

class SaleFilters extends BaseFilters {
  String? code;

  @override
  void clear() {
    code = null;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      if (code?.isNotEmpty == true) 'code': code,
    };
  }

  @override
  void update(String key, String? value) {
    switch (key) {
      case 'code':
        code = value?.trim();
        break;
    }
  }
}
