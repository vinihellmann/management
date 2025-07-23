import 'package:flutter/material.dart';
import 'package:management/core/components/app_loader.dart';
import 'package:management/core/themes/app_colors.dart';

enum AppButtonType { filled, outline, text, fab, save, edit, remove }

class AppButton extends StatefulWidget {
  final String? text;
  final IconData? icon;
  final Future<void> Function()? onPressed;
  final String? tooltip;
  final AppButtonType type;
  final Color? color;
  final bool? isLoading;

  const AppButton({
    super.key,
    this.text,
    this.icon,
    this.onPressed,
    this.tooltip,
    this.color,
    this.type = AppButtonType.filled,
    this.isLoading,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  Future<void> _handlePress() async {
    if (widget.isLoading == true || widget.onPressed == null) return;

    await widget.onPressed?.call();
  }

  Widget _buildChild() {
    if (widget.isLoading == true) {
      return AppLoader(color: AppColors.darkText, strokeWidth: 2, size: 20);
    }

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
            backgroundColor: WidgetStatePropertyAll(widget.color?.withAlpha(50)),
            foregroundColor: WidgetStatePropertyAll(widget.color),
          ),
          child: child,
        );

      case AppButtonType.outline:
        return OutlinedButton(
          onPressed: _handlePress,
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(widget.color?.withAlpha(50)),
            foregroundColor: WidgetStatePropertyAll(widget.color),
            side: WidgetStatePropertyAll(
              BorderSide(
                color: widget.color?.withAlpha(100) ?? Theme.of(context).colorScheme.primary.withAlpha(100),
              ),
            ),
          ),
          child: child,
        );

      case AppButtonType.text:
        return TextButton(
          onPressed: _handlePress,
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(widget.color?.withAlpha(50)),
            foregroundColor: WidgetStatePropertyAll(widget.color),
          ),
          child: child,
        );

      case AppButtonType.fab:
        return FloatingActionButton(
          heroTag: null,
          tooltip: widget.tooltip,
          backgroundColor: widget.color,
          onPressed: _handlePress,
          child: Icon(widget.icon),
        );

      case AppButtonType.save:
        return FloatingActionButton(
          heroTag: null,
          tooltip: 'Salvar',
          backgroundColor: AppColors.tertiary,
          onPressed: _handlePress,
          child: Icon(Icons.done),
        );

      case AppButtonType.edit:
        return FloatingActionButton(
          heroTag: null,
          tooltip: 'Editar',
          backgroundColor: AppColors.secondary,
          onPressed: _handlePress,
          child: Icon(Icons.edit),
        );

      case AppButtonType.remove:
        return FloatingActionButton(
          heroTag: null,
          tooltip: 'Remover',
          backgroundColor: Theme.of(context).colorScheme.error,
          onPressed: _handlePress,
          child: Icon(Icons.delete),
        );
    }
  }
}
