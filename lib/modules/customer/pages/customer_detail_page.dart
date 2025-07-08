import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:management/core/components/app_button.dart';
import 'package:management/core/components/app_layout.dart';
import 'package:management/core/constants/app_route_names.dart';
import 'package:management/core/themes/app_colors.dart';
import 'package:management/modules/customer/models/customer_model.dart';
import 'package:management/modules/customer/providers/customer_detail_provider.dart';
import 'package:management/shared/utils/utils.dart';
import 'package:provider/provider.dart';

class CustomerDetailPage extends StatelessWidget {
  final CustomerModel customer;

  const CustomerDetailPage({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => CustomerDetailProvider(ctx.read()),
      child: _CustomerDetailView(customer),
    );
  }
}

class _CustomerDetailView extends StatelessWidget {
  final CustomerModel c;

  const _CustomerDetailView(this.c);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<CustomerDetailProvider>();

    return AppLayout(
      title: 'Detalhes do Cliente',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: AppColors.primary.withAlpha(25),
                        child: Text(
                          c.name?.substring(0, 1).toUpperCase() ?? '',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c.name?.toUpperCase() ?? '',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Código: ${c.code}',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  _buildInfoRow(Icons.badge, 'CPF/CNPJ', c.document),
                  _buildInfoRow(Icons.storefront, 'Fantasia', c.fantasy),
                  _buildInfoRow(Icons.phone, 'Telefone', c.phone),
                  _buildInfoRow(Icons.email, 'Email', c.email),
                  _buildInfoRow(
                    Icons.location_on,
                    'Endereço',
                    '${c.address}, ${c.number}, ${c.neighborhood}',
                  ),
                  _buildInfoRow(
                    Icons.map,
                    'Cidade / Estado',
                    '${c.city} / ${c.state}',
                  ),
                  _buildInfoRow(Icons.pin_drop, 'CEP', c.zipcode),
                  if (c.complement?.isNotEmpty == true)
                    _buildInfoRow(
                      Icons.info_outline,
                      'Complemento',
                      c.complement,
                    ),
                  if (c.contact?.isNotEmpty == true)
                    _buildInfoRow(
                      Icons.person,
                      'Contato',
                      c.contact,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 160),
          ],
        ),
      ),
      floatingActionButton: Column(
        spacing: 24,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AppButton(
            type: AppButtonType.remove,
            onPressed: () async {
              final confirmed = await Utils.showDeleteDialog(context);
              if (confirmed == true) {
                await provider.delete(c);
                if (context.mounted) context.pop(true);
              }
            },
          ),
          AppButton(
            type: AppButtonType.edit,
            onPressed: () async {
              final result = await context.push<bool>(
                AppRouteNames.customerForm,
                extra: c,
              );
              if (result == true && context.mounted) context.pop(true);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(value ?? '-', style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
