import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:management/core/components/app_date_text_field.dart';
import 'package:management/core/components/app_layout.dart';
import 'package:management/core/components/app_list_header.dart';
import 'package:management/core/components/app_loader.dart';
import 'package:management/core/components/app_pagination.dart';
import 'package:management/core/components/app_text_field.dart';
import 'package:management/core/constants/app_route_names.dart';
import 'package:management/modules/sale/components/sale_list_item.dart';
import 'package:management/modules/sale/providers/sale_list_provider.dart';
import 'package:management/modules/sale/repositories/sale_repository.dart';
import 'package:provider/provider.dart';

class SaleListPage extends StatelessWidget {
  const SaleListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          SaleListProvider(context.read<SaleRepository>())..getData(),
      child: const _SaleListView(),
    );
  }
}

class _SaleListView extends StatelessWidget {
  const _SaleListView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SaleListProvider>();
    final sales = provider.items;

    return AppLayout(
      title: 'Vendas',
      body: Column(
        children: [
          AppListHeader(
            totalItems: provider.totalItems,
            totalItemsShown: provider.totalItemsShown,
            onAdd: () async {
              final result = await context.pushNamed(AppRouteNames.saleForm);
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
                initialValue: provider.orderBy,
                decoration: const InputDecoration(labelText: 'Ordenar por'),
                items: const [
                  DropdownMenuItem(
                    value: 'code ASC',
                    child: Text('Código (1-9)'),
                  ),
                  DropdownMenuItem(
                    value: 'customerName ASC',
                    child: Text('Nome do Cliente (A-Z)'),
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
              AppTextField(
                label: 'Cliente',
                initialValue: provider.filters.customerName,
                onChanged: (v) => provider.updateFilter('customerName', v),
              ),
              AppDateTextField(
                label: 'Data Inicial',
                initialDate: provider.filters.initialDate,
                onChanged: (v) => provider.updateFilter('initialDate', v),
              ),
              AppDateTextField(
                label: 'Data Final',
                initialDate: provider.filters.finalDate,
                onChanged: (v) => provider.updateFilter('finalDate', v),
              ),
            ],
          ),
          if (provider.isLoading)
            const Expanded(child: Center(child: AppLoader()))
          else if (sales.isEmpty)
            const Expanded(
              child: Center(child: Text('Nenhum registro encontrado')),
            )
          else
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: sales.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemBuilder: (_, index) {
                        final sale = sales[index];
                        return SaleListItem(
                          sale: sale,
                          onTap: () async {
                            final result = await context.pushNamed(
                              AppRouteNames.saleDetail,
                              extra: sale,
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
