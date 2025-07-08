import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:management/core/components/app_section_form_card.dart';
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
    final customer = provider.customer;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (customer.id == null)
          GestureDetector(
            onTap: () => _onSelectCustomer(context),
            child: Container(
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.primary.withAlpha(15),
                border: Border.all(color: AppColors.primary, width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.person_search,
                    size: 28,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Selecione um cliente',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          GestureDetector(
            onTap: () => _onSelectCustomer(context),
            child: AppFormSectionCard(
              title: 'Dados do Cliente',
              children: [
                _buildInfo(Icons.person, 'Nome/Razão Social', customer.name!),
                _buildInfo(
                  Icons.badge,
                  'Nome Fantasia',
                  customer.fantasy ?? '',
                ),
                _buildInfo(
                  Icons.text_snippet_rounded,
                  'CPF/CNPJ',
                  customer.document!,
                ),
                _buildInfo(Icons.email, 'Email', customer.email ?? ''),
                _buildInfo(Icons.phone, 'Telefone', customer.phone ?? ''),
                _buildInfo(
                  Icons.home,
                  'Endereço',
                  '${customer.address}, ${customer.number}, ${customer.neighborhood}',
                ),
                _buildInfo(
                  Icons.location_city,
                  'Cidade/Estado',
                  '${customer.city}/${customer.state}',
                ),
                _buildInfo(Icons.pin_drop, 'CEP', customer.zipcode ?? ''),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildInfo(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.bodySmall),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTextStyles.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _onSelectCustomer(BuildContext context) async {
    final result = await context.pushNamed(AppRouteNames.customerSelect);
    if (result is CustomerModel && context.mounted) {
      context.read<SaleFormProvider>().setCustomer(result);
    }
  }
}
