import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:intl/intl.dart';
import 'package:management/core/components/app_button.dart';
import 'package:management/core/themes/app_colors.dart';
import 'package:management/modules/sale/models/sale_status_enum.dart';

class Utils {
  static String? dateToPtBr(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static double? parseToDouble(String text) {
    return double.tryParse(text.replaceAll('.', '').replaceAll(',', '.'));
  }

  static String? parseToCurrency(double value) {
    return CurrencyInputFormatter(
          thousandSeparator: ThousandSeparator.Period,
          mantissaLength: 2,
        )
        .formatEditUpdate(
          TextEditingValue.empty,
          TextEditingValue(text: value.toStringAsFixed(2)),
        )
        .text;
  }

  static Future<bool?> showDeleteDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Deseja realmente deletar o registro?'),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          AppButton(
            color: AppColors.lightError,
            type: AppButtonType.outline,
            text: 'Cancelar',
            onPressed: () async => Navigator.pop(ctx, false),
          ),
          AppButton(
            color: AppColors.secondary,
            type: AppButtonType.outline,
            text: 'Confirmar',
            onPressed: () async => Navigator.pop(ctx, true),
          ),
        ],
      ),
    );
  }

  static Color getStatusColor(SaleStatusEnum status, ThemeData theme) {
    switch (status) {
      case SaleStatusEnum.open:
        return Colors.blue;
      case SaleStatusEnum.awaitingPayment:
        return AppColors.warning;
      case SaleStatusEnum.confirmed:
        return theme.colorScheme.primary;
      case SaleStatusEnum.sent:
        return Colors.teal;
      case SaleStatusEnum.completed:
        return theme.colorScheme.secondary;
      case SaleStatusEnum.canceled:
        return theme.colorScheme.error;
    }
  }
}
