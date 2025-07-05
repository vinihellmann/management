import 'package:flutter/material.dart';
import 'package:management/core/components/app_layout.dart';
import 'package:management/core/themes/app_colors.dart';
import 'package:management/core/themes/app_text_styles.dart';
import 'package:management/modules/dashboard/components/dashboard_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppLayout(
      title: 'Dashboard',
      showBack: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Visão geral', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 16),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            children: [
              DashboardCard(
                title: 'Clientes',
                value: '128',
                icon: Icons.people,
                color: AppColors.primary,
              ),
              DashboardCard(
                title: 'Vendas do mês',
                value: 'R\$ 12.560,00',
                icon: Icons.attach_money,
                color: AppColors.secondary,
              ),
              DashboardCard(
                title: 'A receber',
                value: 'R\$ 5.420,00',
                icon: Icons.payment,
                color: Colors.orange,
              ),
              DashboardCard(
                title: 'Ordens em aberto',
                value: '8',
                icon: Icons.build,
                color: Colors.redAccent,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Gráficos e relatórios', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 16),
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
