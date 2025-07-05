import 'package:flutter/material.dart';

enum AppButtonType { filled, outline, text, fab }

class AppButton extends StatefulWidget {
  final String? text;
  final IconData? icon;
  final Future<void> Function()? onPressed;
  final String? tooltip;
  final AppButtonType type;
  final Color? color;

  const AppButton({
    super.key,
    this.text,
    this.icon,
    this.onPressed,
    this.tooltip,
    this.color,
    this.type = AppButtonType.filled,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  Future<void> _handlePress() async {
    if (widget.onPressed == null) return;

    await widget.onPressed?.call();
  }

  Widget _buildChild() {
    final hasText = widget.text != null && widget.text!.isNotEmpty;
    final hasIcon = widget.icon != null;

    if (hasText && hasIcon) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(widget.icon, size: 18),
          const SizedBox(width: 8),
          Text(widget.text!),
        ],
      );
    }

    if (hasIcon) return Icon(widget.icon);
    if (hasText) return Text(widget.text!);

    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    final child = _buildChild();

    switch (widget.type) {
      case AppButtonType.filled:
        return ElevatedButton(
          onPressed: _handlePress,
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(widget.color),
          ),
          child: child,
        );

      case AppButtonType.outline:
        return OutlinedButton(
          onPressed: _handlePress,
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(widget.color),
          ),
          child: child,
        );

      case AppButtonType.text:
        return TextButton(
          onPressed: _handlePress,
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(widget.color),
          ),
          child: child,
        );

      case AppButtonType.fab:
        return FloatingActionButton(
          tooltip: widget.tooltip,
          backgroundColor: widget.color,
          onPressed: _handlePress,
          child: Icon(widget.icon),
        );
    }
  }
}
