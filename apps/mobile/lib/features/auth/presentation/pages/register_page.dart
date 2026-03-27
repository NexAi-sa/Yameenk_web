library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../../../../core/responsive_scaffold.dart';
import '../../../../widgets/app_logo.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/validators/password_validator.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailPhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _passwordError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Returns a localized error string if the password fails policy, or null.
  String? _validatePassword() {
    final result = validatePassword(_passwordController.text);
    switch (result) {
      case PasswordValidationResult.tooShort:
        return S.of(context).password_tooShort;
      case PasswordValidationResult.needsUppercase:
        return S.of(context).password_needsUppercase;
      case PasswordValidationResult.needsDigit:
        return S.of(context).password_needsDigit;
      case PasswordValidationResult.valid:
        return null;
    }
  }

  void _handleRegister() {
    final name = _nameController.text.trim();
    final identity = _emailPhoneController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty || identity.isEmpty || password.isEmpty) {
      _showError(S.of(context).login_errorPhoneInvalid);
      return;
    }

    final pwError = _validatePassword();
    if (pwError != null) {
      setState(() => _passwordError = pwError);
      return;
    }

    context.read<AuthCubit>().register(
          name: name,
          email: identity,
          password: password,
        );
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, textAlign: TextAlign.right),
        backgroundColor: AppColors.danger,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go('/family');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).success_title)),
          );
        } else if (state is AuthFailureState) {
          _showError(state.message);
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.primaryContainer],
            ),
          ),
          child: SafeArea(
            child: Row(
              children: [
                if (MediaQuery.of(context).size.width > 900)
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xxxl),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AppLogo(size: 100),
                          const SizedBox(height: AppSpacing.xl),
                          Text(
                            'رحلتك نحو الرعاية\nتبدأ من هنا',
                            style: AppTextStyles.displayLg.copyWith(
                                color: Colors.white, fontSize: 48),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            'انضم إلى مجتمع يمينك واستمتع بتجربة رقمية مصممة خصيصاً لراحتك وسلامتك.',
                            style: AppTextStyles.bodyLg
                                .copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.sizeOf(context).width < 600
                          ? AppSpacing.md
                          : AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    padding: EdgeInsets.all(
                      MediaQuery.sizeOf(context).width < 600
                          ? AppSpacing.lg
                          : AppSpacing.xxl,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 40,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ResponsiveCenter(
                      maxWidth: 480,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const AppLogo(size: 120),
                            const SizedBox(height: AppSpacing.lg),
                            Text(S.of(context).login_title,
                                style: AppTextStyles.heading2,
                                textAlign: TextAlign.right),
                            const SizedBox(height: AppSpacing.xs),
                            Text(S.of(context).login_subtitle,
                                style: AppTextStyles.bodySecondary,
                                textAlign: TextAlign.right),
                            const SizedBox(height: AppSpacing.lg),
                            _buildLabel(S.of(context).setup_fullName),
                            TextField(
                              controller: _nameController,
                              textAlign: TextAlign.right,
                              decoration: const InputDecoration(
                                hintText: 'د. أحمد السعد',
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            _buildLabel(S.of(context).login_phoneHint),
                            TextField(
                              controller: _emailPhoneController,
                              textAlign: TextAlign.right,
                              decoration: const InputDecoration(
                                hintText: 'name@example.com',
                                prefixIcon: Icon(Icons.mail_outline),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            _buildLabel('كلمة المرور'),
                            TextField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              textAlign: TextAlign.right,
                              onChanged: (_) {
                                if (_passwordError != null) {
                                  setState(
                                      () => _passwordError = _validatePassword());
                                }
                              },
                              decoration: InputDecoration(
                                hintText: '••••••••',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined),
                                  onPressed: () => setState(() =>
                                      _obscurePassword = !_obscurePassword),
                                ),
                              ),
                            ),
                            if (_passwordError != null)
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 6, right: 4),
                                child: Text(
                                  _passwordError!,
                                  style: AppTextStyles.bodySecondary.copyWith(
                                    color: AppColors.danger,
                                    fontSize: 13,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            const SizedBox(height: AppSpacing.xl),
                            BlocBuilder<AuthCubit, AuthState>(
                              builder: (context, state) {
                                final isLoading = state is AuthLoading;
                                return ElevatedButton(
                                  onPressed:
                                      isLoading ? null : _handleRegister,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 18),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.arrow_back,
                                                size: 20),
                                            const SizedBox(width: 8),
                                            Text(
                                                S.of(context).login_confirm),
                                          ],
                                        ),
                                );
                              },
                            ),
                            const SizedBox(height: AppSpacing.xxl),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () => context.go('/welcome'),
                                  child: const Text('تسجيل الدخول',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                const Text('لديك حساب بالفعل؟'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, right: 4),
      child: Text(text,
          style: AppTextStyles.label
              .copyWith(color: AppColors.onSurfaceVariant),
          textAlign: TextAlign.right),
    );
  }
}
