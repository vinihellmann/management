import 'package:management/core/models/base_filters.dart';

class ProductFilters extends BaseFilters {
  String? code;
  String? name;
  String? brand;
  String? group;

  @override
  void clear() {
    code = null;
    name = null;
    brand = null;
    group = null;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      if (code?.isNotEmpty == true) 'code': code,
      if (name?.isNotEmpty == true) 'name': name,
      if (brand?.isNotEmpty == true) 'brand': brand,
      if (group?.isNotEmpty == true) '"group"': group,
    };
  }

  @override
  void update(String key, dynamic value) {
    switch (key) {
      case 'code':
        code = value?.trim();
        break;
      case 'name':
        name = value?.trim();
        break;
      case 'brand':
        brand = value?.trim();
        break;
      case 'group':
        group = value?.trim();
        break;
    }
  }
}
