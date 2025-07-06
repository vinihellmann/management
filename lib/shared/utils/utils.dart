import 'package:flutter/material.dart';

class Utils {
  static double? parseCurrency(String text) {
    return double.tryParse(text.replaceAll('.', '').replaceAll(',', '.'));
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
