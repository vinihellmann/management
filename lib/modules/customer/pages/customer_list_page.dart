import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:management/core/components/app_layout.dart';
import 'package:management/core/components/app_list_header.dart';
import 'package:management/core/components/app_loader.dart';
import 'package:management/core/components/app_pagination.dart';
import 'package:management/core/components/app_text_field.dart';
import 'package:management/core/constants/app_route_names.dart';
import 'package:management/modules/customer/components/customer_list_item.dart';
import 'package:management/modules/customer/providers/customer_list_provider.dart';
import 'package:management/modules/customer/repositories/customer_repository.dart';
import 'package:provider/provider.dart';

class CustomerListPage extends StatelessWidget {
  const CustomerListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          CustomerListProvider(context.read<CustomerRepository>())..getData(),
      child: const _CustomerListView(),
    );
  }
}

class _CustomerListView extends StatelessWidget {
  const _CustomerListView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CustomerListProvider>();
    final customers = provider.items;

    return AppLayout(
      title: 'Clientes',
      body: Column(
        children: [
          AppListHeader(
            totalItems: provider.totalItems,
            totalItemsShown: provider.totalItemsShown,
            onAdd: () async {
              final result = await context.pushNamed(
                AppRouteNames.customerForm,
              );
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
                    value: 'name ASC',
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
              AppTextField(
                label: 'Nome/Razão Social',
                initialValue: provider.filters.name,
                onChanged: (v) => provider.updateFilter('name', v),
              ),
              AppTextField(
                label: 'CPF/CNPJ',
                initialValue: provider.filters.document,
                onChanged: (v) => provider.updateFilter('document', v),
              ),
            ],
          ),
          if (provider.isLoading)
            const Expanded(child: Center(child: AppLoader()))
          else if (customers.isEmpty)
            const Expanded(
              child: Center(child: Text('Nenhum cliente encontrado')),
            )
          else
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: customers.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (_, index) {
                        final c = customers[index];
                        return CustomerListItem(
                          customer: c,
                          onTap: () async {
                            final result = await context.pushNamed(
                              AppRouteNames.customerDetail,
                              extra: c,
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
