library;

import 'package:equatable/equatable.dart';

enum SubscriptionPlan { free, monthlyPlus, yearlyPlus }

class SubscriptionState extends Equatable {
  final SubscriptionPlan plan;
  final DateTime? expiresAt;
  final bool isLoading;
  final String? errorMessage;

  const SubscriptionState({
    this.plan = SubscriptionPlan.free,
    this.expiresAt,
    this.isLoading = false,
    this.errorMessage,
  });

  bool get isPlus => plan != SubscriptionPlan.free;
  bool get isExpired =>
      expiresAt != null && expiresAt!.isBefore(DateTime.now());
  bool get isActive => isPlus && !isExpired;

  SubscriptionState copyWith({
    SubscriptionPlan? plan,
    DateTime? expiresAt,
    bool? isLoading,
    String? errorMessage,
  }) =>
      SubscriptionState(
        plan: plan ?? this.plan,
        expiresAt: expiresAt ?? this.expiresAt,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [plan, expiresAt, isLoading, errorMessage];
}
