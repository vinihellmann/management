import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:management/core/models/app_exception.dart';
import 'package:management/core/models/zip_model.dart';

class AppZipService {
  Future<ZipModel?> fetchZipCode(String zip) async {
    try {
      final url = Uri.parse('https://viacep.com.br/ws/$zip/json');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['erro'] == true) return null;

        return ZipModel.fromJson(json);
      } else {
        throw AppException('Erro ao buscar CEP');
      }
    } catch (e, stack) {
      throw AppException(
        'Erro ao buscar CEP',
        detail: e.toString(),
        stackTrace: stack,
      );
    }
  }
}
