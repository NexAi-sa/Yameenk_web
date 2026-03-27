import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/auth/welcome_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/family/dashboard_screen.dart';
import '../screens/family/chat_screen.dart';
import '../screens/patient/record_reading_screen.dart';
import '../screens/patient/medical_profile_screen.dart';
import '../screens/patient/profile_setup_screen.dart';
import '../screens/patient/health_reports_screen.dart';
import '../screens/services/services_marketplace_screen.dart';
import '../screens/subscription/yameenak_plus_screen.dart';
import '../screens/privacy/consent_screen.dart';
import '../screens/privacy/privacy_settings_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/welcome',
    routes: [
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // ✅ PDPL: شاشة الموافقة الصريحة (إلزامية بعد أول تسجيل دخول)
      GoRoute(
        path: '/consent',
        builder: (context, state) => const ConsentScreen(),
      ),
      // ✅ PDPL: مركز تفضيلات الخصوصية
      GoRoute(
        path: '/privacy-settings',
        builder: (context, state) => const PrivacySettingsScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => child,
        routes: [
          // مسارات الأسرة
          GoRoute(
            path: '/family',
            builder: (context, state) => const FamilyDashboardScreen(),
          ),
          GoRoute(
            path: '/family/chat',
            builder: (context, state) => const ChatScreen(),
          ),
          // مسارات المسن — الملف الطبي
          GoRoute(
            path: '/patient/profile',
            builder: (context, state) => const MedicalProfileScreen(),
          ),
          GoRoute(
            path: '/patient/profile/setup',
            builder: (context, state) => const ProfileSetupScreen(),
          ),
          // التقارير الصحية
          GoRoute(
            path: '/patient/reports',
            builder: (context, state) => const HealthReportsScreen(),
          ),
          // تسجيل القراءات
          GoRoute(
            path: '/patient/record',
            builder: (context, state) {
              final type = state.uri.queryParameters['type'] ?? 'blood_sugar';
              final label = state.uri.queryParameters['label'] ?? 'قراءتك';
              return RecordReadingScreen(type: type, label: label);
            },
          ),
          // سوق الخدمات
          GoRoute(
            path: '/services',
            builder: (context, state) => const ServicesMarketplaceScreen(),
          ),
          // يمينك بلس
          GoRoute(
            path: '/plus',
            builder: (context, state) => const YameenakPlusScreen(),
          ),
        ],
      ),
    ],
  );
});
