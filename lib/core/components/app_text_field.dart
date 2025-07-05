import 'package:flutter/material.dart';
import 'package:management/core/themes/app_text_styles.dart';

class AppTextField extends StatelessWidget {
  final bool isRequired;
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? maxLines;
  final FormFieldValidator<String>? validator;
  final void Function(String)? onChanged;
  final bool enabled;
  final String? initialValue;

  const AppTextField({
    super.key,
    this.isRequired = false,
    required this.label,
    this.hint,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.initialValue,
  });

  String? _isRequired(String? value) {
    if (value == null || value == '') return 'Campo Obrigatório';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.bodyMedium),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: initialValue,
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          validator: isRequired ? _isRequired : validator,
          onChanged: onChanged,
          enabled: enabled,
          style: AppTextStyles.input.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}
