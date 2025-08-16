import 'package:flutter/material.dart';
import 'package:management/core/components/app_base_detail_page.dart';
import 'package:management/core/models/base_detail_info.dart';
import 'package:management/modules/finance/models/finance_model.dart';
import 'package:management/modules/finance/providers/finance_detail_provider.dart';
import 'package:management/shared/utils/utils.dart';
import 'package:provider/provider.dart';

class FinanceDetailPage extends StatelessWidget {
  final FinanceModel finance;

  const FinanceDetailPage({super.key, required this.finance});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => FinanceDetailProvider(ctx.read()),
      child: _FinanceDetailView(finance),
    );
  }
}

class _FinanceDetailView extends StatelessWidget {
  final FinanceModel finance;

  const _FinanceDetailView(this.finance);

  String _formatValue(double? v) {
    return 'R\$ ${Utils.parseToCurrency(v ?? 0)}';
  }

  @override
  Widget build(BuildContext context) {
    return AppBaseDetailPage(
      title: 'Detalhes do Financeiro',
      avatarIcon: finance.type.icon,
      avatarLabel: 'Financeiro ${finance.code ?? ''}',
      subtitle: Utils.dateToPtBr(finance.createdAt ?? DateTime.now()),
      onEdit: null,
      onDelete: null,
      details: <BaseDetailInfo>[
        BaseDetailInfo(finance.type.icon, 'Tipo', finance.type.label),
        BaseDetailInfo(
          Icons.attach_money,
          'Valor',
          _formatValue(finance.value),
        ),
        BaseDetailInfo(
          Icons.event,
          'Vencimento',
          finance.dueDate != null ? Utils.dateToPtBr(finance.dueDate!) : '-',
        ),
        if ((finance.saleCode ?? '').isNotEmpty)
          BaseDetailInfo(Icons.shopping_bag, 'Venda', finance.saleCode),
        BaseDetailInfo(Icons.person, 'Cliente', finance.customerName ?? '-'),
        BaseDetailInfo(Icons.info, 'Status', finance.status.label),
        if (finance.notes != null && finance.notes!.trim().isNotEmpty)
          BaseDetailInfo(Icons.notes, 'Observações', finance.notes),
        BaseDetailInfo(
          Icons.schedule,
          'Criado em',
          finance.createdAt != null
              ? Utils.dateToPtBr(finance.createdAt!)
              : '-',
        ),
        BaseDetailInfo(
          Icons.update,
          'Atualizado em',
          finance.updatedAt != null
              ? Utils.dateToPtBr(finance.updatedAt!)
              : '-',
        ),
      ],
      options: <Widget>[],
      children: null,
    );
  }
}
