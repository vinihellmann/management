import 'package:flutter/material.dart';
import 'package:management/core/constants/app_asset_names.dart';
import 'package:management/modules/login/providers/login_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (c) => LoginController(c.read()),
      child: const _LoginPageView(),
    );
  }
}

class _LoginPageView extends StatelessWidget {
  const _LoginPageView();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<LoginController>();
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: ctrl.formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const _Header(),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: ctrl.email,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [
                              AutofillHints.username,
                              AutofillHints.email,
                            ],
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'E-mail',
                            ),
                            validator: _validateEmail,
                          ),
                          const SizedBox(height: 12),
                          Selector<LoginController, bool>(
                            selector: (_, c) => c.obscurePassword,
                            builder: (_, obscure, __) {
                              return TextFormField(
                                controller: ctrl.password,
                                textInputAction: TextInputAction.done,
                                autofillHints: const [AutofillHints.password],
                                obscureText: obscure,
                                decoration: InputDecoration(
                                  labelText: 'Senha',
                                  suffixIcon: IconButton(
                                    onPressed: ctrl.toggleObscurePassword,
                                    icon: Icon(
                                      obscure
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    tooltip: obscure
                                        ? 'Mostrar senha'
                                        : 'Ocultar senha',
                                  ),
                                ),
                                validator: _validatePassword,
                                onFieldSubmitted: (_) async {
                                  if (!ctrl.isLoading) await ctrl.signIn();
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 5),
                          if (ctrl.isLoading) ...[
                            const SizedBox(height: 25),
                            Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                          ] else ...[
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: ctrl.resetPassword,
                                child: const Text('Esqueci minha senha'),
                              ),
                            ),
                            const SizedBox(height: 5),
                            SizedBox(
                              height: 48,
                              child: FilledButton(
                                onPressed: () async => await ctrl.signIn(),
                                child: const Text('Acessar'),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: theme.dividerColor.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    'ou',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: theme.dividerColor.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 48,
                              child: OutlinedButton.icon(
                                onPressed: () async =>
                                    await ctrl.signInWithGoogle(),
                                icon: Image.asset(
                                  AppAssetNames.googleLogoPath,
                                  width: 20,
                                  height: 20,
                                ),
                                label: Text(
                                  'Entrar com Google',
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 6),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static String? _validateEmail(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Informe seu e-mail';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
    if (!ok) return 'E-mail inválido';
    return null;
  }

  static String? _validatePassword(String? v) {
    final value = (v ?? '');
    if (value.isEmpty) return 'Informe sua senha';
    if (value.length < 6) return 'Mínimo de 6 caracteres';
    return null;
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: CircleAvatar(
            radius: 40,
            backgroundColor: theme.scaffoldBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: ClipOval(
                child: Image.asset(
                  AppAssetNames.logoPath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text('Bem-vindo', style: theme.textTheme.headlineLarge),
        const SizedBox(height: 4),
        Text(
          'Acesse sua conta para continuar',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
