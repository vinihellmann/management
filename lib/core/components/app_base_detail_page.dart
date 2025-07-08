import 'package:flutter/material.dart';
import 'package:management/core/components/app_button.dart';
import 'package:management/core/components/app_layout.dart';
import 'package:management/core/models/base_detail_info.dart';
import 'package:management/core/themes/app_colors.dart';

class AppBaseDetailPage extends StatelessWidget {
  final String title;
  final IconData avatarIcon;
  final String avatarLabel;
  final String? subtitle;
  final List<BaseDetailInfo> details;
  final List<Widget>? children;
  final Future<void> Function()? onEdit;
  final Future<void> Function()? onDelete;

  const AppBaseDetailPage({
    super.key,
    required this.title,
    required this.avatarIcon,
    required this.avatarLabel,
    required this.details,
    this.subtitle,
    this.children,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppLayout(
      title: title,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: AppColors.primary.withAlpha(25),
                        child: Icon(
                          avatarIcon,
                          color: AppColors.primary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              avatarLabel,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (subtitle != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  subtitle!,
                                  style: theme.textTheme.bodySmall,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  ...details.map(
                    (d) => _buildInfoRow(d.icon, d.label, d.value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (children != null) ...children!,
            const SizedBox(height: 160),
          ],
        ),
      ),
      floatingActionButton: Column(
        spacing: 24,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AppButton(type: AppButtonType.remove, onPressed: onDelete),
          AppButton(type: AppButtonType.edit, onPressed: onEdit),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(value ?? '-', style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
