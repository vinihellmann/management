import 'package:flutter/material.dart';
import 'package:management/core/extensions/auth_extensions.dart';

class LoggedUserCard extends StatelessWidget {
  const LoggedUserCard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.auth.session?.member;
    final theme = Theme.of(context);

    final String email = user?.email ?? '';
    final String name = user?.displayName ?? '';

    return Card(
      elevation: 0,
      margin: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      surfaceTintColor: theme.colorScheme.surfaceTint,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Bem-vindo, $name',
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            email,
            style: theme.textTheme.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
