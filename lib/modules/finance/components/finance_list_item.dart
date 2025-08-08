import 'package:flutter/material.dart';
import 'package:management/modules/finance/models/finance_model.dart';
import 'package:management/shared/utils/utils.dart';

class FinanceListItem extends StatelessWidget {
  final FinanceModel finance;
  final VoidCallback onTap;

  const FinanceListItem({
    super.key,
    required this.finance,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bool isConfirmed = finance.status == FinanceStatusEnum.confirmed;
    final bool isCanceled = finance.status == FinanceStatusEnum.canceled;
    final bool isOverdue =
        !isConfirmed &&
        !isCanceled &&
        finance.dueDate != null &&
        finance.dueDate!.isBefore(DateTime.now());

    final Color typeColor = finance.type.color;
    final Color statusColor = Utils.getFinanceStatusColor(finance.status, theme);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${finance.code} - ${finance.customerName?.toUpperCase() ?? ''}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.chevron_right, size: 20, color: theme.hintColor),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: typeColor.withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 6,
                      children: [
                        Icon(finance.type.icon, size: 14, color: typeColor),
                        Text(
                          finance.type.label,
                          style: TextStyle(
                            color: typeColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      finance.status.label,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  if (isOverdue) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error.withAlpha(25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'VENCIDO',
                        style: TextStyle(
                          color: theme.colorScheme.error,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Venc.: ${finance.dueDate != null ? Utils.dateToPtBr(finance.dueDate!) : '-'}',
                    style: theme.textTheme.bodySmall,
                  ),
                  Text(
                    'Valor: R\$ ${Utils.parseToCurrency(finance.value ?? 0)}',
                    style: theme.textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Criado: ${finance.createdAt != null ? Utils.dateToPtBr(finance.createdAt!) : '-'}',
                    style: theme.textTheme.bodySmall,
                  ),
                  if ((finance.saleCode ?? '').isNotEmpty)
                    Text(
                      'Venda: ${finance.saleCode}',
                      style: theme.textTheme.bodySmall,
                    ),
                ],
              ),

              if ((finance.notes ?? '').trim().isNotEmpty) ...[
                const SizedBox(height: 1),
                Text(
                  'Obs: ${finance.notes}',
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
