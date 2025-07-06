import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:management/core/components/app_button.dart';
import 'package:management/core/components/app_layout.dart';
import 'package:management/core/components/app_loader.dart';
import 'package:management/core/components/app_pagination.dart';
import 'package:management/core/components/app_text_field.dart';
import 'package:management/core/constants/app_route_names.dart';
import 'package:management/core/themes/app_text_styles.dart';
import 'package:management/modules/customer/components/customer_list_item.dart';
import 'package:management/modules/customer/providers/customer_list_provider.dart';
import 'package:management/modules/customer/repositories/customer_repository.dart';
import 'package:management/modules/dashboard/providers/dashboard_provider.dart';
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
      padding: 12,
      title: 'Clientes',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: Row(
              children: [
                Text(
                  'Exibindo ${provider.totalItemsShown} de ${provider.totalItems} registros',
                ),
                Spacer(),
                IconButton(
                  tooltip: 'Adicionar',
                  icon: Icon(Icons.add),
                  onPressed: () async {
                    final result = await context.pushNamed(
                      AppRouteNames.customerForm,
                    );

                    if (result == true && context.mounted) {
                      provider.getData();
                      context.read<DashboardProvider>().loadData();
                    }
                  },
                ),
                IconButton(
                  tooltip: 'Filtrar',
                  icon: Icon(Icons.filter_list),
                  onPressed: () async => _showFilterModal(context),
                ),
              ],
            ),
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
                              context.read<DashboardProvider>().loadData();
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

  void _showFilterModal(BuildContext context) {
    final provider = context.read<CustomerListProvider>();

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
                  label: 'Nome',
                  initialValue: provider.filters.name,
                  onChanged: (v) => provider.updateFilter('name', v),
                ),
                AppTextField(
                  label: 'Documento',
                  initialValue: provider.filters.document,
                  onChanged: (v) => provider.updateFilter('document', v),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppButton(
                      tooltip: 'Limpar',
                      text: 'Limpar',
                      icon: Icons.clear_all,
                      onPressed: () async {
                        provider.clearFilters();
                        ctx.pop();
                      },
                    ),
                    AppButton(
                      tooltip: 'Buscar',
                      text: 'Buscar',
                      icon: Icons.search,
                      onPressed: () async {
                        provider.getData();
                        ctx.pop();
                      },
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
