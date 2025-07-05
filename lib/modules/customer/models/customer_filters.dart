import 'package:management/core/models/base_filters.dart';

class CustomerFilters extends BaseFilters {
  String? code;
  String? name;
  String? document;

  @override
  void clear() {
    code = null;
    name = null;
    document = null;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      if (code?.isNotEmpty == true) 'code': code,
      if (name?.isNotEmpty == true) 'name': name,
      if (document?.isNotEmpty == true) 'document': document,
    };
  }

  @override
  void update(String key, String? value) {
    switch (key) {
      case 'code':
        code = value?.trim();
        break;
      case 'name':
        name = value?.trim();
        break;
      case 'document':
        document = value?.trim();
        break;
    }
  }
}
