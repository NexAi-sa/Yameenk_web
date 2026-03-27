/// شارة الحالة الصحية — Status Badge
library;

import 'package:flutter/material.dart';
import '../app/theme.dart';
import '../main.dart';

enum HealthStatus { normal, needsAttention, alert }

class StatusBadge extends StatelessWidget {
  final HealthStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final (label, color, bgColor) = switch (status) {
      HealthStatus.normal => (l.status_normal, AppColors.success, AppColors.successLight),
      HealthStatus.needsAttention => (l.status_needsAttention, AppColors.warning, AppColors.warningLight),
      HealthStatus.alert => (l.status_alert, AppColors.danger, AppColors.dangerLight),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
