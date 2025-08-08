import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:intl/intl.dart';
import 'package:management/core/components/app_button.dart';
import 'package:management/core/services/app_toast_service.dart';
import 'package:management/core/themes/app_colors.dart';
import 'package:management/modules/finance/models/finance_model.dart';
import 'package:management/modules/sale/models/sale_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';

class Utils {
  static Future<void> exportDatabase(BuildContext context) async {
    try {
      final dbPath = await getDatabasesPath();
      final sourcePath = join(dbPath, 'management.db');

      final directory = await getApplicationDocumentsDirectory();
      final exportPath = join(directory.path, 'management_backup.db');

      final sourceFile = File(sourcePath);
      final exportFile = File(exportPath);

      if (await sourceFile.exists()) {
        await sourceFile.copy(exportFile.path);

        await SharePlus.instance.share(
          ShareParams(
            text: 'Backup do banco de dados',
            files: [XFile(exportFile.path)],
          ),
        );
      } else {
        AppToastService.showError('Banco de dados não encontrado');
      }
    } catch (e) {
      AppToastService.showError('Erro ao exportar banco: $e');
    }
  }

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

  static String? parseToStock(double value) {
    bool isInteger = value == value.roundToDouble();

    return CurrencyInputFormatter(
          thousandSeparator: ThousandSeparator.Period,
          mantissaLength: isInteger ? 0 : 2,
        )
        .formatEditUpdate(
          TextEditingValue.empty,
          TextEditingValue(
            text: isInteger ? value.toStringAsFixed(0) : value.toString(),
          ),
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

  static Future<bool?> showConfirmDialog(
    BuildContext context,
    String text,
  ) async {
    return await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar ação'),
        content: Text(text),
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

  static Color getSaleStatusColor(SaleStatusEnum status, ThemeData theme) {
    switch (status) {
      case SaleStatusEnum.open:
        return Colors.blue;
      case SaleStatusEnum.awaitingPayment:
        return AppColors.tertiary;
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

  static Color getFinanceStatusColor(FinanceStatusEnum status, ThemeData theme) {
    switch (status) {
      case FinanceStatusEnum.pending:
        return Colors.blue;
      case FinanceStatusEnum.confirmed:
        return AppColors.tertiary;
      case FinanceStatusEnum.canceled:
        return theme.colorScheme.error;
    }
  }
}
