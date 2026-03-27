import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import '../../core/responsive_scaffold.dart';
import '../../main.dart';
import '../../services/api_service.dart';
import '../../services/consent_service.dart';
import '../../widgets/app_logo.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  String? _validatePhone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'\s'), '');
    if (cleaned.isEmpty) return context.l10n.login_errorPhone;
    if (!RegExp(r'^5\d{8}$').hasMatch(cleaned)) {
      return context.l10n.login_errorPhoneInvalid;
    }
    return null;
  }

  Future<void> _loginDirectly() async {
    final phone = _phoneController.text.trim();
    final error = _validatePhone(phone);
    if (error != null) {
      _showError(error);
      return;
    }

    setState(() => _loading = true);
    try {
      final api = ref.read(apiServiceProvider);
      // ✅ Cancel OTP: الدخول المباشر برمز تجريبي (أو تخطي الرمز)
      // ملاحظة: المبرمج يجب أن يتأكد أن الباكيند يقبل هذا الرمز للحسابات التجريبية
      await api.verifyOtp('+966$phone', '123456');
      
      if (mounted) {
        final consentState = ref.read(consentProvider);
        if (!consentState.hasCompletedInitialConsent) {
          context.go('/consent');
        } else {
          context.go('/family');
        }
      }
    } catch (e) {
      _showError(context.l10n.login_errorOtpInvalid);
    } finally {
      setState(() => _loading = false);
    }
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
    final l = context.l10n;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.loginBackground),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
              child: ResponsiveCenter(
                maxWidth: 480,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AppLogo(size: 140),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      l.tagline,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyLg.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: _buildPhoneStep(),
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

  Widget _buildPhoneStep() {
    final l = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l.login_title,
            style: AppTextStyles.heading2, textAlign: TextAlign.center),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l.login_subtitle,
          style: AppTextStyles.bodySecondary,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xl),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          textAlign: TextAlign.center,
          style: AppTextStyles.stat.copyWith(letterSpacing: 2),
          decoration: InputDecoration(
            hintText: '5XXXXXXXX',
            hintStyle:
                TextStyle(color: AppColors.textMuted.withValues(alpha: 0.5)),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(right: 12, left: 4),
              child: Text(
                '966+',
                style: AppTextStyles.label.copyWith(
                  fontSize: 18,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _PrimaryButton(
          label: l.login_title,
          loading: _loading,
          onPressed: _loginDirectly,
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final bool loading;
  final VoidCallback onPressed;

  const _PrimaryButton({
    required this.label,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      child: loading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            )
          : Text(label),
    );
  }
}
