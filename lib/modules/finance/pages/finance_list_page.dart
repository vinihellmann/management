import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:management/core/components/app_layout.dart';
import 'package:management/core/components/app_list_header.dart';
import 'package:management/core/components/app_loader.dart';
import 'package:management/core/components/app_pagination.dart';
import 'package:management/core/components/app_text_field.dart';
import 'package:management/core/constants/app_route_names.dart';
import 'package:management/modules/finance/components/finance_list_item.dart';
import 'package:management/modules/finance/providers/finance_list_provider.dart';
import 'package:management/modules/finance/repositories/finance_repository.dart';
import 'package:provider/provider.dart';

class FinanceListPage extends StatelessWidget {
  const FinanceListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          FinanceListProvider(context.read<FinanceRepository>())..getData(),
      child: _FinanceListView(),
    );
  }
}

class _FinanceListView extends StatelessWidget {
  const _FinanceListView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FinanceListProvider>();

    return AppLayout(
      title: 'Financeiro',
      body: Column(
        children: [
          AppListHeader(
            totalItems: provider.totalItems,
            totalItemsShown: provider.totalItemsShown,
            onAdd: () async {
              final result = await context.pushNamed(AppRouteNames.financeForm);
              if (result == true && context.mounted) provider.getData();
            },
            onClearFilter: () async {
              provider.clearFilters();
              context.pop();
            },
            onSearchFilter: () async {
              provider.getData();
              context.pop();
            },
            filterContent: [
              DropdownButtonFormField<String>(
                value: provider.orderBy,
                decoration: const InputDecoration(labelText: 'Ordenar por'),
                items: const [
                  DropdownMenuItem(
                    value: 'code ASC',
                    child: Text('Código (1-9)'),
                  ),
                  DropdownMenuItem(
                    value: 'customerName ASC',
                    child: Text('Nome (A-Z)'),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  provider.orderBy = value;
                },
              ),
              AppTextField(
                label: 'Código',
                initialValue: provider.filters.code,
                onChanged: (v) => provider.updateFilter('code', v),
              ),
            ],
          ),
          if (provider.isLoading)
            const Expanded(child: Center(child: AppLoader()))
          else if (provider.items.isEmpty)
            const Expanded(
              child: Center(child: Text('Nenhum registro encontrado')),
            )
          else
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: provider.items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      itemBuilder: (_, index) {
                        final item = provider.items[index];
                        return FinanceListItem(
                          finance: item,
                          onTap: () async {
                            final result = await context.pushNamed(
                              AppRouteNames.financeDetail,
                              extra: item,
                            );
                            if (result == true && context.mounted) {
                              provider.getData();
                            }
                          },
                        );
                      },
                    ),
                  ),
                  AppPagination(
                    currentPage: provider.currentPage,
                    hasPrevious: provider.currentPage > 1,
                    hasNext: provider.hasMore,
                    onPrevious: provider.previousPage,
                    onNext: provider.nextPage,
                    totalPages: provider.totalPages,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
