import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:management/core/components/app_base_detail_page.dart';
import 'package:management/core/constants/app_route_names.dart';
import 'package:management/core/models/base_detail_info.dart';
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
    final provider = context.watch<CustomerDetailProvider>();

    return AppBaseDetailPage(
      title: 'Detalhes do Cliente',
      avatarIcon: Icons.person,
      avatarLabel: '${c.code} - ${c.name?.toUpperCase()}',
      subtitle: c.document,
      details: [
        BaseDetailInfo(Icons.badge, 'Nome Fantasia', c.fantasy),
        BaseDetailInfo(Icons.email, 'Email', c.email),
        BaseDetailInfo(Icons.phone, 'Telefone', c.phone),
        BaseDetailInfo(Icons.person_pin, 'Contato', c.contact),
        BaseDetailInfo(
          Icons.home,
          'Endereço',
          '${c.address}, ${c.number}, ${c.neighborhood}',
        ),
        BaseDetailInfo(
          Icons.location_city,
          'Cidade/Estado',
          '${c.city}/${c.state}',
        ),
        BaseDetailInfo(Icons.pin_drop, 'CEP', c.zipcode),
        BaseDetailInfo(Icons.edit_location, 'Complemento', c.complement),
      ],
      onDelete: () async {
        final confirmed = await Utils.showDeleteDialog(context);
        if (confirmed == true) {
          await provider.delete(c);
          if (context.mounted) context.pop(true);
        }
      },
      onEdit: () async {
        final result = await context.pushNamed(
          AppRouteNames.customerForm,
          extra: c,
        );
        if (result == true && context.mounted) context.pop(true);
      },
    );
  }
}
