class AppException implements Exception {
  final String message;
  final String? detail;
  final StackTrace? stackTrace;

  AppException(this.message, {this.detail, this.stackTrace});

  @override
  String toString() =>
      'AppException: $message${detail != null ? '\nDetail: $detail' : ''}';
}
