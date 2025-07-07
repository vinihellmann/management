import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:intl/intl.dart';

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
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}
