import 'package:flutter/material.dart';
import 'package:management/core/components/app_document_text_field.dart';
import 'package:management/core/components/app_loader.dart';
import 'package:management/core/components/app_section_form_card.dart';
import 'package:management/core/components/app_select.dart';
import 'package:management/core/components/app_text_field.dart';
import 'package:management/modules/customer/models/customer_city_model.dart';
import 'package:management/modules/customer/models/customer_state_model.dart';
import 'package:management/modules/customer/providers/customer_form_provider.dart';
import 'package:management/shared/formatters/input_formatters.dart';
import 'package:provider/provider.dart';

class CustomerFormFields extends StatelessWidget {
  const CustomerFormFields({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CustomerFormProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppFormSectionCard(
          title: 'Dados Principais',
          children: [
            AppTextField(
              isRequired: true,
              label: 'Nome/Razão Social',
              controller: provider.nameController,
            ),
            AppTextField(
              label: 'Apelido/Nome Fantasia',
              controller: provider.fantasyController,
            ),
            AppDocumentTextField(
              isRequired: true,
              label: 'CPF/CNPJ',
              controller: provider.documentController,
            ),
          ],
        ),
        AppFormSectionCard(
          title: 'Endereço',
          children: [
            AppTextField(
              isRequired: true,
              label: 'Logradouro',
              controller: provider.addressController,
            ),
            Row(
              spacing: 12,
              children: [
                Expanded(
                  child: AppTextField(
                    isRequired: true,
                    label: 'Bairro',
                    controller: provider.neighborhoodController,
                  ),
                ),
                Expanded(
                  child: AppTextField(
                    isRequired: true,
                    label: 'Número',
                    controller: provider.numberController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            AppTextField(
              label: 'CEP',
              isRequired: true,
              controller: provider.zipController,
              keyboardType: TextInputType.number,
              inputFormatters: [InputFormatters.zipMask],
              suffixIcon: provider.isSearching
                  ? AppLoader(padding: EdgeInsets.all(16), strokeWidth: 2)
                  : IconButton(
                      onPressed: () => provider.fillAddress(),
                      icon: Icon(Icons.search),
                    ),
            ),
            AppSelect<CustomerStateModel>(
              isRequired: true,
              label: 'Estado',
              value: provider.selectedState,
              onChanged: (s) => provider.selectState(s),
              items: provider.states
                  .map((s) => DropdownMenuItem(value: s, child: Text(s.name)))
                  .toList(),
            ),
            AppSelect<CustomerCityModel>(
              isRequired: true,
              label: 'Cidade',
              value: provider.selectedCity,
              onChanged: (c) => provider.selectCity(c),
              items: provider.cities
                  .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                  .toList(),
            ),
            AppTextField(
              label: 'Complemento',
              controller: provider.complementController,
            ),
          ],
        ),
        AppFormSectionCard(
          title: 'Contato',
          children: [
            AppTextField(
              label: 'Email',
              controller: provider.emailController,
              inputFormatters: [InputFormatters.emailMask],
              keyboardType: TextInputType.emailAddress,
            ),
            AppTextField(
              label: 'Telefone',
              controller: provider.phoneController,
              inputFormatters: [InputFormatters.phoneMask],
              keyboardType: TextInputType.phone,
            ),
            AppTextField(
              label: 'Contato',
              controller: provider.contactController,
            ),
          ],
        ),
        SizedBox(height: 60),
      ],
    );
  }
}
