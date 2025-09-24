import 'package:flutter/material.dart';
import 'package:management/core/components/app_nav_bar.dart';
import 'package:management/modules/auth/controllers/auth_controller.dart';
import 'package:management/modules/auth/models/auth_session.dart';
import 'package:provider/provider.dart';

class BlockedPage extends StatelessWidget {
  const BlockedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final session = auth.session;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppNavBar(
        showBack: false,
        withDrawer: false,
        title: 'Acesso bloqueado',
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 64,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Seu acesso está bloqueado',
                      style: theme.textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _buildMessage(session),
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () => auth.signOut(),
                      icon: const Icon(Icons.logout),
                      label: const Text('Sair da conta'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _buildMessage(AuthSession? session) {
    if (session == null) {
      return 'Não foi possível validar sua conta.';
    }

    if (!session.tenant.licenseValid) {
      return 'A licença da empresa expirou em '
          '${session.tenant.licenseUntil?.toString().substring(0, 10) ?? 'data desconhecida'}.';
    }

    if (!session.member.active) {
      return 'Seu usuário foi desativado nesta empresa.';
    }

    return 'Entre em contato com o administrador para mais informações.';
  }
}
