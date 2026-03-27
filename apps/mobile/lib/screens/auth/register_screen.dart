import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import '../../core/responsive_scaffold.dart';
import '../../widgets/app_logo.dart';
import '../../l10n/app_localizations.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailPhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final name = _nameController.text.trim();
    final identity = _emailPhoneController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty || identity.isEmpty || password.isEmpty) {
      _showError(S.of(context).login_errorPhoneInvalid);
      return;
    }

    setState(() => _loading = true);
    try {
      // ✅ محاكاة التسجيل - في الإنتاج سيتم الاتصال بالـ API
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        context.go('/login');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).success_title)),
        );
      }
    } catch (e) {
      _showError(S.of(context).login_errorOtpInvalid);
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
    return Scaffold(
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
              // Column 1: Visual/Hero (Only on Large Screens)
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
                            color: Colors.white,
                            fontSize: 48,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          'انضم إلى مجتمع يمينك واستمتع بتجربة رقمية مصممة خصيصاً لراحتك وسلامتك.',
                          style: AppTextStyles.bodyLg.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Column 2: Form
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.all(AppSpacing.lg),
                  padding: const EdgeInsets.all(AppSpacing.xxl),
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
                          const AppLogo(size: 80),
                          const SizedBox(height: AppSpacing.xl),
                          Text(
                            S.of(context).login_title,
                            style: AppTextStyles.heading2,
                            textAlign: TextAlign.right,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            S.of(context).login_subtitle,
                            style: AppTextStyles.bodySecondary,
                            textAlign: TextAlign.right,
                          ),
                          const SizedBox(height: AppSpacing.xxl),

                          // Name
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

                          // Identity
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

                          // Password
                          _buildLabel('كلمة المرور'),
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                              hintText: '••••••••',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),

                          // CTA
                          ElevatedButton(
                            onPressed: _loading ? null : _handleRegister,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            child: _loading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.arrow_back, size: 20),
                                      const SizedBox(width: 8),
                                      Text(S.of(context).login_confirm),
                                    ],
                                  ),
                          ),

                          const SizedBox(height: AppSpacing.xl),

                          // Divider
                          Row(
                            children: [
                              Expanded(
                                  child: Divider(
                                      color:
                                          AppColors.outline.withValues(alpha: 0.2))),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.md),
                                child: Text('أو سجل عبر',
                                    style: AppTextStyles.caption),
                              ),
                              Expanded(
                                  child: Divider(
                                      color:
                                          AppColors.outline.withValues(alpha: 0.2))),
                            ],
                          ),

                          const SizedBox(height: AppSpacing.lg),

                          // Social buttons
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.apple),
                                  label: const Text('Apple'),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.g_mobiledata, size: 32),
                                  label: const Text('Google'),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: AppSpacing.xxl),

                          // Footer
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () => context.go('/login'),
                                child: const Text(
                                  'تسجيل الدخول',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
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
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, right: 4),
      child: Text(
        text,
        style: AppTextStyles.label.copyWith(color: AppColors.onSurfaceVariant),
        textAlign: TextAlign.right,
      ),
    );
  }
}
