import 'package:flutter/material.dart';
import 'package:management/core/components/app_button.dart';
import 'package:management/core/themes/app_text_styles.dart';

class AppListHeader extends StatelessWidget {
  const AppListHeader({
    super.key,
    required this.totalItemsShown,
    required this.totalItems,
    required this.onAdd,
    required this.filterContent,
    required this.onClearFilter,
    required this.onSearchFilter,
  });

  final int totalItemsShown;
  final int totalItems;
  final VoidCallback onAdd;

  final List<Widget> filterContent;
  final Future<void> Function()? onClearFilter;
  final Future<void> Function()? onSearchFilter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total de registros',
                  style: theme.textTheme.bodySmall,
                ),
                Text(
                  '$totalItemsShown de $totalItems',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          AppButton(
            type: AppButtonType.outline,
            tooltip: 'Filtrar',
            onPressed: () async => _showFilterModal(context),
            icon: Icons.filter_alt_outlined,
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: onAdd,
            style: ButtonStyle(
              elevation: WidgetStatePropertyAll(0),
              padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 5)),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(30)
              ))
            ),
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Filtros', style: AppTextStyles.headlineMedium),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(ctx).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Column(spacing: 16, children: filterContent),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppButton(
                      tooltip: 'Limpar filtros',
                      text: 'Limpar',
                      icon: Icons.clear_all,
                      onPressed: onClearFilter,
                    ),
                    AppButton(
                      tooltip: 'Aplicar filtros',
                      text: 'Buscar',
                      icon: Icons.search,
                      onPressed: onSearchFilter,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
