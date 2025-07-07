import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:management/core/components/app_container_card.dart';
import 'package:management/core/components/app_section_description.dart';
import 'package:management/core/constants/app_route_names.dart';
import 'package:management/core/themes/app_colors.dart';
import 'package:management/core/themes/app_text_styles.dart';
import 'package:management/modules/customer/models/customer_model.dart';
import 'package:management/modules/sale/providers/sale_form_provider.dart';
import 'package:provider/provider.dart';

class SaleFormCustomerCard extends StatelessWidget {
  const SaleFormCustomerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SaleFormProvider>();
    return Column(
      children: [
        Row(
          children: [
            AppSectionDescription(description: 'Dados do Cliente'),
            Spacer(),
            TextButton.icon(
              icon: Icon(Icons.search),
              label: Text('Buscar'),
              onPressed: () => onSelectCustomer(context),
            ),
          ],
        ),
        if (provider.customer.id == null) ...[
          GestureDetector(
            onTap: () => onSelectCustomer(context),
            child: AppContainerCard(
              child: Row(
                spacing: 12,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people, size: 28, color: AppColors.primary),
                  Center(
                    child: Text(
                      'Selecione um cliente',
                      style: AppTextStyles.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ] else ...[
          AppContainerCard(
            child: Column(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RowInfo(
                  label: 'Nome/Razão Social:',
                  content: provider.customer.name!.toUpperCase(),
                ),
                RowInfo(
                  label: 'CPF/CNPJ:',
                  content: provider.customer.document!,
                ),
                RowInfo(
                  label: 'Logradouro:',
                  content: provider.customer.address!,
                ),
                RowInfo(
                  label: 'Bairro:',
                  content: provider.customer.neighborhood!,
                ),
                RowInfo(label: 'Número:', content: provider.customer.number!),
                RowInfo(
                  label: 'Cidade:',
                  content:
                      '${provider.customer.city}/${provider.customer.state}',
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Future<void> onSelectCustomer(BuildContext context) async {
    final result = await context.pushNamed(AppRouteNames.customerSelect);

    if (result is CustomerModel && context.mounted) {
      context.read<SaleFormProvider>().setCustomer(result);
    }
  }
}

class RowInfo extends StatelessWidget {
  const RowInfo({super.key, required this.label, required this.content});

  final String label;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Text(label),
        Expanded(
          child: Text(
            content,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
