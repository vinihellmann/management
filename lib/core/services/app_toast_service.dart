import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:management/core/themes/app_colors.dart';

class AppToastService {
  static void _show({
    required String message,
    required Color backgroundColor,
    ToastGravity gravity = ToastGravity.BOTTOM,
    Toast toastLength = Toast.LENGTH_SHORT,
  }) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: AppColors.darkText,
      fontSize: 14,
    );
  }

  static void showSuccess(
    String message, {
    Toast toastLength = Toast.LENGTH_SHORT,
  }) {
    _show(
      message: message,
      backgroundColor: AppColors.secondary,
      toastLength: toastLength,
    );
  }

  static void showError(
    String message, {
    Toast toastLength = Toast.LENGTH_LONG,
  }) {
    _show(
      message: message,
      backgroundColor: Colors.red[700]!,
      toastLength: toastLength,
    );
  }

  static void showInfo(
    String message, {
    Toast toastLength = Toast.LENGTH_SHORT,
  }) {
    _show(
      message: message,
      backgroundColor: AppColors.primary,
      toastLength: toastLength,
    );
  }
}
