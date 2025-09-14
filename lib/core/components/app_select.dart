import 'package:flutter/material.dart';

class AppSelect<T> extends StatelessWidget {
  const AppSelect({
    super.key,
    required this.label,
    this.value,
    this.onChanged,
    this.items,
    this.isRequired = false,
  });

  final String label;
  final bool isRequired;
  final T? value;
  final void Function(T?)? onChanged;
  final List<DropdownMenuItem<T>>? items;

  String? _isRequired(T? value) {
    if (value == null) return 'Campo Obrigatório';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        DropdownButtonFormField(
          initialValue: value,
          onChanged: onChanged,
          items: items,
          validator: isRequired ? _isRequired : null,
        ),
      ],
    );
  }
}
