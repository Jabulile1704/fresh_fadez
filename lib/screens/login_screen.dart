import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
import '../utils/constants.dart';
import '../widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController(
    text: 'jabu@example.com',
  );
  final TextEditingController _passwordController = TextEditingController(
    text: 'password',
  );
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Still simulated. Real credentials go in when auth lands — this screen
  // then calls AuthRepository instead of waiting.
  Future<void> _handleSignIn() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) {
      return;
    }
    setState(() => _isLoading = false);
    await Navigator.of(context).pushReplacementNamed(AppRoutes.home);
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppMessages.emailRequired;
    }
    if (!RegExp(ValidationPatterns.emailPattern).hasMatch(value.trim())) {
      return AppMessages.invalidEmail;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppMessages.passwordRequired;
    }
    if (value.length < 6) {
      return AppMessages.passwordTooShort;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 56, 28, 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    borderRadius: BorderRadius.circular(19),
                  ),
                  child: Icon(
                    Icons.content_cut,
                    size: 26,
                    color: scheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 30),
                Text('Fresh\nFadez', style: theme.textTheme.displaySmall),
                const SizedBox(height: 12),
                Text(
                  "Bloemfontein's chair, booked in\nabout thirty seconds.",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 44),
                AppTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'you@example.com',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: _validateEmail,
                ),
                const SizedBox(height: 18),
                AppTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Your password',
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  validator: _validatePassword,
                  suffix: IconButton(
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 19,
                      color: scheme.onSurfaceVariant,
                    ),
                    tooltip: _obscurePassword
                        ? 'Show password'
                        : 'Hide password',
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => _notYet(context, 'Password reset'),
                    child: const Text('Forgot password?'),
                  ),
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleSignIn,
                  child: _isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: scheme.onPrimary,
                          ),
                        )
                      : const Text('Sign in'),
                ),
                const SizedBox(height: 26),
                Row(
                  children: [
                    Expanded(child: Divider(color: scheme.outline)),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.medium - 2,
                      ),
                      child: Text('or', style: theme.textTheme.labelMedium),
                    ),
                    Expanded(child: Divider(color: scheme.outline)),
                  ],
                ),
                const SizedBox(height: 26),
                OutlinedButton.icon(
                  onPressed: _isLoading
                      ? null
                      : () => Navigator.of(
                          context,
                        ).pushReplacementNamed(AppRoutes.home),
                  icon: const Icon(Icons.person_outline, size: 18),
                  label: const Text('Continue as guest'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: scheme.outline),
                    minimumSize: const Size.fromHeight(
                      AppButtonStyles.primaryHeight,
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                Center(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text('New here? ', style: theme.textTheme.bodyMedium),
                      GestureDetector(
                        onTap: () => _notYet(context, 'Sign up'),
                        child: Text(
                          'Create an account',
                          style: theme.textTheme.labelLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _notYet(BuildContext context, String what) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$what is not built yet.')));
  }
}
