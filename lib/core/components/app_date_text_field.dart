import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:management/core/themes/app_text_styles.dart';
import 'package:management/shared/utils/utils.dart';

class AppDateTextField extends StatelessWidget {
  final String label;
  final DateTime? initialDate;
  final void Function(DateTime?)? onChanged;
  final bool enabled;
  final bool isRequired;
  final String? hint;
  final DateFormat format;
  final DateTime? firstDate;
  final DateTime? lastDate;

  AppDateTextField({
    super.key,
    required this.label,
    this.initialDate,
    this.onChanged,
    this.enabled = true,
    this.isRequired = false,
    this.hint,
    DateFormat? format,
    this.firstDate,
    this.lastDate,
  }) : format = format ?? DateFormat('dd/MM/yyyy');

  String? _isRequired(DateTime? date) {
    if (isRequired && date == null) return 'Campo Obrigatório';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(
      text: initialDate != null ? format.format(initialDate!) : '',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: enabled
              ? () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: initialDate ?? DateTime.now(),
                    firstDate: firstDate ?? DateTime(2000),
                    lastDate: lastDate ?? DateTime(2100),
                    helpText: 'Selecione a data',
                    cancelText: 'Cancelar',
                    confirmText: 'Confirmar',
                  );
                  
                  if (picked != null) {
                    controller.text = Utils.dateToPtBr(picked)!;
                    onChanged?.call(picked);
                  }
                }
              : null,
          child: AbsorbPointer(
            child: TextFormField(
              controller: controller,
              readOnly: true,
              enabled: enabled,
              validator: (_) => _isRequired(initialDate),
              style: AppTextStyles.input.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: hint ?? 'Selecionar data',
                suffixIcon: const Icon(Icons.calendar_today),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
