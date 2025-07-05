import 'package:flutter/material.dart';

class AppLoader extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final Color? color;

  const AppLoader({
    super.key,
    this.size = 24.0,
    this.strokeWidth = 3.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor =
        color ??
        (theme.brightness == Brightness.dark
            ? theme.colorScheme.onSurface
            : theme.colorScheme.primary);

    return SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
      ),
    );
  }
}
