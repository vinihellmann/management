import 'package:flutter/material.dart';
import 'package:management/core/components/app_button.dart';

class AppPagination extends StatelessWidget {
  final int currentPage;
  final Future<void> Function()? onNext;
  final Future<void> Function()? onPrevious;
  final bool hasNext;
  final bool hasPrevious;
  final int totalPages;

  const AppPagination({
    super.key,
    required this.currentPage,
    this.onNext,
    this.onPrevious,
    this.hasNext = true,
    this.hasPrevious = true,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(64),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppButton(
              type: AppButtonType.outline,
              tooltip: 'Página Anterior',
              onPressed: hasPrevious ? onPrevious : null,
              icon: Icons.chevron_left,
            ),
            Text(
              'Página $currentPage de $totalPages',
              style: theme.textTheme.bodyMedium,
            ),
            AppButton(
              type: AppButtonType.outline,
              tooltip: 'Próxima Página',
              onPressed: hasNext ? onNext : null,
              icon: Icons.chevron_right,
            ),
          ],
        ),
      ),
    );
  }
}
