import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:management/core/components/app_layout.dart';
import 'package:management/core/components/app_list_header.dart';
import 'package:management/core/components/app_loader.dart';
import 'package:management/core/components/app_pagination.dart';
import 'package:management/core/components/app_text_field.dart';
import 'package:management/core/constants/app_route_names.dart';
import 'package:management/core/extensions/auth_extensions.dart';
import 'package:management/modules/product/components/product_list_item.dart';
import 'package:management/modules/product/models/product_model.dart';
import 'package:management/modules/product/providers/product_list_provider.dart';
import 'package:management/modules/product/repositories/product_repository.dart';
import 'package:provider/provider.dart';

class ProductListPage extends StatelessWidget {
  final void Function(ProductModel)? onSelect;

  const ProductListPage({super.key, this.onSelect});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          ProductListProvider(context.read<ProductRepository>())..getData(),
      child: _ProductListView(onSelect),
    );
  }
}

class _ProductListView extends StatelessWidget {
  final void Function(ProductModel)? onSelect;

  const _ProductListView(this.onSelect);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductListProvider>();
    final products = provider.items;

    return AppLayout(
      title: 'Produtos',
      body: Column(
        children: [
          AppListHeader(
            showAddButton: context.isManager,
            totalItems: provider.totalItems,
            totalItemsShown: provider.totalItemsShown,
            onAdd: () async {
              final result = await context.pushNamed(AppRouteNames.productForm);
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
                label: 'Marca',
                initialValue: provider.filters.brand,
                onChanged: (v) => provider.updateFilter('brand', v),
              ),
              AppTextField(
                label: 'Grupo',
                initialValue: provider.filters.group,
                onChanged: (v) => provider.updateFilter('group', v),
              ),
            ],
          ),
          if (provider.isLoading)
            const Expanded(child: Center(child: AppLoader()))
          else if (products.isEmpty)
            const Expanded(
              child: Center(child: Text('Nenhum registro encontrado')),
            )
          else
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: products.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemBuilder: (_, index) {
                        final product = products[index];
                        return ProductListItem(
                          product: product,
                          onTap: () async {
                            if (onSelect != null) {
                              onSelect?.call(product);
                              return;
                            }

                            final result = await context.pushNamed(
                              AppRouteNames.productDetail,
                              extra: product,
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
