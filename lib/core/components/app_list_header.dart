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
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 8, 12),
      child: Row(
        children: [
          Text('Exibindo $totalItemsShown de $totalItems registros'),
          Spacer(),
          IconButton(
            tooltip: 'Adicionar',
            icon: Icon(Icons.add),
            onPressed: onAdd,
          ),
          IconButton(
            tooltip: 'Filtrar',
            icon: Icon(Icons.filter_list),
            onPressed: () async => _showFilterModal(context),
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
              spacing: 12,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Filtros', style: AppTextStyles.headlineMedium),
                const SizedBox(height: 4),
                ...filterContent,
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppButton(
                      tooltip: 'Limpar',
                      text: 'Limpar',
                      icon: Icons.clear_all,
                      onPressed: onClearFilter,
                    ),
                    AppButton(
                      tooltip: 'Buscar',
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
