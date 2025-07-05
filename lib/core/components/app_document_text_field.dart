import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:management/core/components/app_text_field.dart';
import 'package:management/shared/formatters/input_formatters.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AppDocumentTextField extends StatefulWidget {
  final String label;
  final bool isRequired;
  final TextEditingController controller;

  const AppDocumentTextField({
    super.key,
    required this.label,
    required this.controller,
    this.isRequired = false,
  });

  @override
  State<AppDocumentTextField> createState() => _AppDocumentTextFieldState();
}

class _AppDocumentTextFieldState extends State<AppDocumentTextField> {
  late final MaskTextInputFormatter _cpfFormatter;
  late final MaskTextInputFormatter _cnpjFormatter;
  MaskTextInputFormatter? _activeFormatter;

  @override
  void initState() {
    super.initState();

    _cpfFormatter = InputFormatters.cpfMask;
    _cnpjFormatter = InputFormatters.cnpjMask;

    final initial = widget.controller.text;
    _activeFormatter = _getFormatter(initial);
    _applyFormatter(initial, force: true);
  }

  MaskTextInputFormatter _getFormatter(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    return digits.length > 11 ? _cnpjFormatter : _cpfFormatter;
  }

  void _applyFormatter(String rawValue, {bool force = false}) {
    final formatter = _getFormatter(rawValue);
    final digits = rawValue.replaceAll(RegExp(r'\D'), '');
    final newText = formatter.maskText(digits);

    if (force || widget.controller.text != newText) {
      if (_activeFormatter?.getMask() != formatter.getMask()) {
        setState(() => _activeFormatter = formatter);
      }

      final selectionIndex = newText.length;
      widget.controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: selectionIndex),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: widget.label,
      isRequired: widget.isRequired,
      controller: widget.controller,
      keyboardType: TextInputType.number,
      onChanged: (value) => _applyFormatter(value),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }
}
