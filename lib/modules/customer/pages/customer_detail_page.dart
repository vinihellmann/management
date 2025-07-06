import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:management/core/components/app_button.dart';
import 'package:management/core/components/app_detail_info_card.dart';
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
  const _CustomerDetailView(this.c);

  final CustomerModel c;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CustomerDetailProvider>();

    return AppLayout(
      withDrawer: false,
      title: 'Detalhes',
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Wrap(
          spacing: 24,
          runSpacing: 24,
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          children: [
            AppDetailInfoCard(
              width: double.infinity,
              title: 'Código',
              value: c.code ?? '',
              icon: Icons.qr_code,
              color: AppColors.primary,
            ),
            AppDetailInfoCard(
              width: double.infinity,
              title: 'Nome',
              value: '${c.name?.toUpperCase()}',
              icon: Icons.person,
              color: AppColors.primary,
            ),
            AppDetailInfoCard(
              width: double.infinity,
              title: 'CPF/CNPJ',
              value: c.document ?? '',
              icon: Icons.badge,
              color: AppColors.primary,
            ),
            AppDetailInfoCard(
              width: double.infinity,
              title: 'Email',
              value: c.email ?? '',
              icon: Icons.email,
              color: AppColors.primary,
            ),
            AppDetailInfoCard(
              width: double.infinity,
              title: 'Telefone',
              value: c.phone ?? '',
              icon: Icons.phone,
              color: AppColors.primary,
            ),
            AppDetailInfoCard(
              width: double.infinity,
              title: 'Endereço',
              value: '${c.address}, ${c.number}, ${c.neighborhood}',
              icon: Icons.home,
              color: AppColors.primary,
            ),
            AppDetailInfoCard(
              width: double.infinity,
              title: 'CEP',
              value: '${c.zipcode} - ${c.city}/${c.state}',
              icon: Icons.pin_drop,
              color: AppColors.primary,
            ),
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
}
