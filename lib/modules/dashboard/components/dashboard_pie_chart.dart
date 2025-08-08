import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:management/modules/sale/models/sale_model.dart';
import 'package:management/shared/utils/utils.dart';

class DashboardPieChart extends StatelessWidget {
  final Map<String, double> data;

  const DashboardPieChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final filteredData = data.entries.where((e) => e.value > 0).toList();
    final total = filteredData.fold(0.0, (sum, e) => sum + e.value);
    final theme = Theme.of(context);

    if (total == 0 || filteredData.isEmpty) {
      return AspectRatio(
        aspectRatio: 1.2,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              'Sem dados disponíveis',
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 1.2,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: PieChart(
            PieChartData(
              sections: filteredData.map((entry) {
                final status = SaleStatusEnum.values.firstWhere(
                  (e) => e.name == entry.key,
                  orElse: () => SaleStatusEnum.open,
                );
                final percent = (entry.value / total * 100).toStringAsFixed(1);
                return PieChartSectionData(
                  value: entry.value,
                  title: '${status.label}\n$percent%',
                  color: Utils.getSaleStatusColor(status, theme),
                  radius: 60,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList(),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
            ),
          ),
        ),
      ),
    );
  }
}
