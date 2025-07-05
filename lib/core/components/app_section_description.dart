import 'package:flutter/material.dart';
import 'package:management/core/themes/app_text_styles.dart';

class AppSectionDescription extends StatelessWidget {
  const AppSectionDescription({super.key, required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(description, style: AppTextStyles.headlineMedium),
        const SizedBox(height: 16),
      ],
    );
  }
}
