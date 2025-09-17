import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEnvService {
  AppEnvService._();

  static late final AppEnvService instance;

  static String get envName =>
      const String.fromEnvironment('ENV', defaultValue: 'dev');

  static String get _envFile =>
      {
        'prod': '.env.prod',
        'stg': '.env.stg',
        'qa': '.env.qa',
        'dev': '.env',
      }[envName] ??
      '.env';

  static Future<void> init() async {
    await dotenv.load(fileName: _envFile);
    instance = AppEnvService._();
    instance._validate();
  }

  String _getStr(String key, {String? fallback, bool required = false}) {
    final fromDefine = String.fromEnvironment(key, defaultValue: '');
    if (fromDefine.isNotEmpty) return fromDefine;

    final fromDotenv = dotenv.env[key];
    if (fromDotenv != null && fromDotenv.isNotEmpty) return fromDotenv;

    if (fallback != null) return fallback;
    if (required) {
      throw StateError('ENV "$key" ausente para ${AppEnvService.envName}');
    }

    return '';
  }

  // bool _getBool(String key, {bool? fallback, bool required = false}) {
  //   final raw = _getStr(
  //     key,
  //     required: required,
  //     fallback: fallback?.toString(),
  //   );
  //   return raw.toLowerCase() == 'true' || raw == '1';
  // }

  // int _getInt(String key, {int? fallback, bool required = false}) {
  //   final raw = _getStr(
  //     key,
  //     required: required,
  //     fallback: fallback?.toString(),
  //   );
  //   return int.tryParse(raw) ??
  //       (required
  //           ? (throw StateError('ENV "$key" inválido (esperado int)'))
  //           : (fallback ?? 0));
  // }

  void _validate() {
    _getStr('GOOGLE_SERVER_CLIENT_ID', required: true);
  }

  String get googleServerClientId =>
      _getStr('GOOGLE_SERVER_CLIENT_ID', required: true);
}
