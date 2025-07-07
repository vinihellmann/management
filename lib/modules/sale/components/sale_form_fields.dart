import 'package:flutter/material.dart';
import 'package:management/core/components/app_section_description.dart';
import 'package:management/core/components/app_select.dart';
import 'package:management/core/components/app_text_field.dart';
import 'package:management/modules/sale/components/sale_form_customer_card.dart';
import 'package:management/modules/sale/models/sale_status_enum.dart';
import 'package:management/modules/sale/providers/sale_form_provider.dart';
import 'package:provider/provider.dart';

class SaleFormFields extends StatelessWidget {
  const SaleFormFields({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SaleFormProvider>();
    return SingleChildScrollView(
      padding: EdgeInsets.all(12),
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SaleFormCustomerCard(),
          AppSectionDescription(description: 'Dados do Pagamento'),
          AppSelect<String>(
            isRequired: true,
            label: 'Forma de Pagamento',
            value: provider.paymentMethod,
            onChanged: (s) => provider.setPaymentMethod(s),
            items: provider.paymentMethodOptions
                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                .toList(),
          ),
          AppSelect<String>(
            isRequired: true,
            label: 'Condição de Pagamento',
            value: provider.paymentCondition,
            onChanged: (s) => provider.setPaymentCondition(s),
            items: provider.paymentConditionOptions
                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                .toList(),
          ),
          AppSectionDescription(description: 'Outras Informações'),
          AppSelect<SaleStatusEnum>(
            isRequired: true,
            label: 'Status',
            value: provider.selectedStatus,
            onChanged: (s) => provider.setStatus(s),
            items: SaleStatusEnum.values
                .map((s) => DropdownMenuItem(value: s, child: Text(s.label)))
                .toList(),
          ),
          AppTextField(
            label: 'Anotações',
            maxLines: 3,
            controller: provider.notesController,
          ),
          SizedBox(height: 60),
        ],
      ),
    );
  }
}
