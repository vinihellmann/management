import 'package:flutter/material.dart';
import 'package:management/core/components/app_section_description.dart';

class AppFormSectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const AppFormSectionCard({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionDescription(description: title),
          ...children,
        ],
      ),
    );
  }
}
