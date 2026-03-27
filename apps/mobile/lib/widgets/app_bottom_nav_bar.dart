library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../app/theme.dart';

/// Shared bottom navigation bar used by the [ShellRoute] scaffold.
///
/// Displays five tabs: Home, Assistant, Services, Reports, Profile.
/// Active tab is derived from the current [GoRouter] location.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({super.key});

  /// Maps each tab index to its GoRouter path.
  static const _routes = [
    '/family', // 0 — Home
    '/family/chat', // 1 — Assistant
    '/services', // 2 — Services
    '/patient/reports', // 3 — Reports
    '/patient/profile', // 4 — Profile
  ];

  /// Determines the active tab index from the current route.
  static int _indexFromLocation(String location) {
    if (location.startsWith('/patient/profile')) return 4;
    if (location.startsWith('/patient/reports')) return 3;
    if (location.startsWith('/services')) return 2;
    if (location.startsWith('/family/chat')) return 1;
    return 0; // default: Home
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final activeIndex = _indexFromLocation(location);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, bottomPadding + 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 40,
            offset: const Offset(0, -12),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavBtn(
            icon: Icons.home_rounded,
            label: 'Home',
            isActive: activeIndex == 0,
            onTap: () => context.go(_routes[0]),
          ),
          _NavBtn(
            icon: Icons.smart_toy_outlined,
            label: 'Assistant',
            isActive: activeIndex == 1,
            onTap: () => context.go(_routes[1]),
          ),
          _NavBtn(
            icon: Icons.medical_services_outlined,
            label: 'Services',
            isActive: activeIndex == 2,
            onTap: () => context.go(_routes[2]),
          ),
          _NavBtn(
            icon: Icons.description_outlined,
            label: 'Reports',
            isActive: activeIndex == 3,
            onTap: () => context.go(_routes[3]),
          ),
          _NavBtn(
            icon: Icons.person_outline_rounded,
            label: 'Profile',
            isActive: activeIndex == 4,
            onTap: () => context.go(_routes[4]),
          ),
        ],
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _NavBtn({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: isActive
                ? BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(16),
                  )
                : null,
            child: Icon(
              icon,
              color: isActive ? AppColors.primary : AppColors.outline,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? AppColors.primary : AppColors.outline,
            ),
          ),
        ],
      ),
    );
  }
}
