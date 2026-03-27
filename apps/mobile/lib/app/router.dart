library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/cubit/auth_cubit.dart';
import '../features/auth/presentation/cubit/auth_state.dart';
import '../features/auth/presentation/pages/welcome_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/family/presentation/pages/family_dashboard_page.dart';
import '../features/chat/presentation/pages/chat_page.dart';
import '../screens/patient/medical_profile_screen.dart';
import '../screens/patient/profile_setup_screen.dart';
import '../screens/patient/health_reports_screen.dart';
import '../screens/patient/record_reading_screen.dart';
import '../screens/services/services_marketplace_screen.dart';
import '../screens/subscription/yameenak_plus_screen.dart';
import '../screens/privacy/consent_screen.dart';
import '../screens/privacy/privacy_settings_screen.dart';
import '../screens/legal/medical_disclaimer_screen.dart';
import '../widgets/app_bottom_nav_bar.dart';

/// SharedPreferences key for fast consent status check.
const kConsentCompletedSpKey = 'pdpl_consent_completed_sp';

/// Paths that do NOT require authentication.
const _publicPaths = <String>{
  '/welcome',
  '/register',
  '/medical-disclaimer',
  '/consent',
};

class AppRouter {
  late final GoRouter router;

  AppRouter({required AuthCubit authCubit}) {
    router = GoRouter(
      initialLocation: '/welcome',
      refreshListenable: GoRouterRefreshStream(authCubit.stream),
      redirect: (context, state) async {
        final isAuthenticated = authCubit.state is AuthAuthenticated;
        final location = state.matchedLocation;
        final isPublic = _publicPaths.contains(location);

        // Show medical disclaimer on first launch (App Store §1.4.1)
        if (location == '/welcome') {
          final accepted = await hasMedicalDisclaimerBeenAccepted();
          if (!accepted) return '/medical-disclaimer';
        }

        // Guard: redirect unauthenticated users away from protected routes.
        if (!isAuthenticated && !isPublic) {
          return '/welcome';
        }

        // Consent gate (PDPL): redirect authenticated but non-consented users.
        if (isAuthenticated && location != '/consent') {
          final prefs = await SharedPreferences.getInstance();
          final consentDone =
              prefs.getBool(kConsentCompletedSpKey) ?? false;
          if (!consentDone) return '/consent';
        }

        // Convenience: send authenticated+consented users past login/register.
        if (isAuthenticated &&
            (location == '/welcome' || location == '/register')) {
          return '/family';
        }

        return null; // no redirect
      },
      routes: [
        GoRoute(
          path: '/medical-disclaimer',
          builder: (context, state) => MedicalDisclaimerScreen(
            onAccepted: () => router.go('/welcome'),
          ),
        ),
        GoRoute(
          path: '/welcome',
          builder: (context, state) => const WelcomePage(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: '/consent',
          builder: (context, state) => const ConsentScreen(),
        ),
        GoRoute(
          path: '/privacy-settings',
          builder: (context, state) => const PrivacySettingsScreen(),
        ),
        ShellRoute(
          builder: (context, state, child) => Scaffold(
            body: child,
            bottomNavigationBar: const AppBottomNavBar(),
          ),
          routes: [
            GoRoute(
              path: '/family',
              builder: (context, state) => const FamilyDashboardPage(),
            ),
            GoRoute(
              path: '/family/chat',
              builder: (context, state) => const ChatPage(),
            ),
            GoRoute(
              path: '/patient/profile',
              builder: (context, state) => const MedicalProfileScreen(),
            ),
            GoRoute(
              path: '/patient/profile/setup',
              builder: (context, state) => const ProfileSetupScreen(),
            ),
            GoRoute(
              path: '/patient/reports',
              builder: (context, state) => const HealthReportsScreen(),
            ),
            GoRoute(
              path: '/patient/record',
              builder: (context, state) {
                final type =
                    state.uri.queryParameters['type'] ?? 'blood_sugar';
                final label =
                    state.uri.queryParameters['label'] ?? 'قراءتك';
                return RecordReadingScreen(type: type, label: label);
              },
            ),
            GoRoute(
              path: '/services',
              builder: (context, state) =>
                  const ServicesMarketplaceScreen(),
            ),
            GoRoute(
              path: '/plus',
              builder: (context, state) => const YameenakPlusScreen(),
            ),
          ],
        ),
      ],
    );
  }
}

/// Converts a [Stream] into a [ChangeNotifier] for [GoRouter.refreshListenable].
/// Re-evaluates the redirect callback whenever the stream emits.
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _sub;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
