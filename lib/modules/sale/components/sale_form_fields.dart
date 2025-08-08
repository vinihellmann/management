import 'package:flutter/material.dart';
import 'package:management/core/components/app_section_form_Card.dart';
import 'package:management/core/components/app_select.dart';
import 'package:management/core/components/app_text_field.dart';
import 'package:management/modules/sale/components/sale_form_customer_card.dart';
import 'package:management/modules/sale/models/sale_model.dart';
import 'package:management/modules/sale/providers/sale_form_provider.dart';
import 'package:provider/provider.dart';

class SaleFormFields extends StatelessWidget {
  const SaleFormFields({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SaleFormProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
      child: Column(
        spacing: 12,
        children: [
          const SaleFormCustomerCard(),
          AppFormSectionCard(
            title: 'Dados do Pagamento',
            children: [
              AppSelect<String>(
                isRequired: true,
                label: 'Forma de Pagamento',
                value: provider.paymentMethod,
                onChanged: provider.setPaymentMethod,
                items: provider.paymentMethodOptions
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
              ),
              AppSelect<String>(
                isRequired: true,
                label: 'Condição de Pagamento',
                value: provider.paymentCondition,
                onChanged: provider.setPaymentCondition,
                items: provider.paymentConditionOptions
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
              ),
            ],
          ),
          AppFormSectionCard(
            title: 'Outras Informações',
            children: [
              AppSelect<SaleStatusEnum>(
                isRequired: true,
                label: 'Status',
                value: provider.selectedStatus,
                onChanged: provider.setStatus,
                items: SaleStatusEnumExtension.selectableValues
                    .map(
                      (s) => DropdownMenuItem(value: s, child: Text(s.label)),
                    )
                    .toList(),
              ),
              AppTextField(
                label: 'Anotações',
                maxLines: 3,
                controller: provider.notesController,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
