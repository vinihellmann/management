import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:management/core/themes/app_text_styles.dart';

class AppNavBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBack;
  final Widget? leading;
  final List<Widget>? actions;

  const AppNavBar({
    super.key,
    required this.title,
    this.showBack = true,
    this.onBack,
    this.leading,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final canPop = context.canPop();
    final backIcon = IconButton(
      icon: const Icon(Icons.chevron_left),
      onPressed: onBack ?? () => context.pop(),
    );

    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 80,
      centerTitle: true,
      title: Text(title, style: AppTextStyles.headlineMedium),
      leading: showBack && canPop ? backIcon : leading,
      actions: [...?actions],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
