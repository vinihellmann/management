import 'package:flutter/material.dart';
import 'package:management/core/themes/app_text_styles.dart';

class AppSelect<T> extends StatelessWidget {
  const AppSelect({
    super.key,
    required this.label,
    this.value,
    this.onChanged,
    this.items,
  });

  final String label;
  final T? value;
  final void Function(T?)? onChanged;
  final List<DropdownMenuItem<T>>? items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.bodyMedium),
        const SizedBox(height: 6),
        DropdownButtonFormField(
          value: value,
          onChanged: onChanged,
          items: items,
        ),
      ],
    );
  }
}
