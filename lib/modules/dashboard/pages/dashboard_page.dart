import 'package:flutter/material.dart';
import 'package:management/core/components/app_layout.dart';
import 'package:management/core/components/app_section_description.dart';
import 'package:management/core/router/app_router.dart';
import 'package:management/core/themes/app_colors.dart';
import 'package:management/modules/dashboard/components/dashboard_pie_chart.dart';
import 'package:management/modules/dashboard/components/summary_Card.dart';
import 'package:management/modules/dashboard/providers/dashboard_provider.dart';
import 'package:management/shared/utils/utils.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => DashboardProvider(ctx.read(), ctx.read()),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatefulWidget {
  const _DashboardView();

  @override
  State<_DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<_DashboardView> with RouteAware {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().loadData();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      AppRouter.routerObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    AppRouter.routerObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    context.read<DashboardProvider>().loadData();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    return AppLayout(
      title: 'Dashboard',
      showBack: false,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppSectionDescription(description: 'Visão Geral'),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SummaryCard(
                  title: 'Clientes',
                  value: '${provider.totalCustomers}',
                  icon: Icons.people,
                  color: AppColors.primary,
                ),
                SummaryCard(
                  title: 'Vendas do mês',
                  value: 'R\$ ${Utils.parseToCurrency(provider.salesThisMonth)}',
                  icon: Icons.attach_money,
                  color: AppColors.secondary,
                ),
                SummaryCard(
                  title: 'A receber',
                  value: 'R\$ ${Utils.parseToCurrency(provider.salesToReceive)}',
                  icon: Icons.payment,
                  color: AppColors.tertiary,
                ),
                SummaryCard(
                  title: 'Vendas em aberto',
                  value: '${provider.salesOpenCount}',
                  icon: Icons.shopping_bag,
                  color: AppColors.lightError,
                ),
              ],
            ),
            const SizedBox(height: 12),
            const AppSectionDescription(description: 'Gráficos e Relatórios'),
            DashboardPieChart(data: provider.salesByStatusMap),
          ],
        ),
      ),
    );
  }
}
