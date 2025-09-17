import 'dart:async';

import 'package:flutter/material.dart';
import 'package:management/core/bootstrap/bootstrap.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };

  runZonedGuarded(
    () async {
      await Bootstrap.init();
    },
    (error, stack) {
      debugPrint('Uncaught zone error: $error\n$stack');
    },
  );
}
