import 'package:flutter/material.dart';
import 'package:management/core/components/app_loader.dart';

class AppLoadingOverlay extends StatelessWidget {
  final bool visible;
  final Color backgroundColor;

  const AppLoadingOverlay({
    super.key,
    required this.visible,
    this.backgroundColor = const Color.fromRGBO(0, 0, 0, 0.3),
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: AbsorbPointer(
        absorbing: true,
        child: Container(
          color: backgroundColor,
          alignment: Alignment.center,
          child: const AppLoader(size: 40),
        ),
      ),
    );
  }
}
