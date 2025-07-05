import 'package:flutter/material.dart';
import 'package:management/core/components/app_detail_info_card.dart';
import 'package:management/core/components/app_layout.dart';
import 'package:management/core/components/app_section_description.dart';
import 'package:management/core/themes/app_colors.dart';
import 'package:management/core/themes/app_text_styles.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppLayout(
      title: 'Dashboard',
      showBack: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: AppSectionDescription(description: 'Visão geral'),
          ),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            children: [
              AppDetailInfoCard(
                width: 160,
                title: 'Clientes',
                value: '128',
                icon: Icons.people,
                color: AppColors.primary,
              ),
              AppDetailInfoCard(
                width: 160,
                title: 'Vendas do mês',
                value: 'R\$ 12.560,00',
                icon: Icons.attach_money,
                color: AppColors.secondary,
              ),
              AppDetailInfoCard(
                width: 160,
                title: 'A receber',
                value: 'R\$ 5.420,00',
                icon: Icons.payment,
                color: Colors.orange,
              ),
              AppDetailInfoCard(
                width: 160,
                title: 'Ordens em aberto',
                value: '8',
                icon: Icons.build,
                color: Colors.redAccent,
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: AppSectionDescription(description: 'Gráficos e relatórios'),
          ),
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(
              'Gráfico de vendas (em breve)',
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
