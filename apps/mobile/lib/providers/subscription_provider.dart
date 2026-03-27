/// مزود حالة الاشتراك — Yameenak Plus
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// أنواع الاشتراك
enum SubscriptionPlan { free, monthlyPlus, yearlyPlus }

/// حالة الاشتراك
class SubscriptionState {
  final SubscriptionPlan plan;
  final DateTime? expiresAt;
  final bool isLoading;

  const SubscriptionState({
    this.plan = SubscriptionPlan.free,
    this.expiresAt,
    this.isLoading = false,
  });

  bool get isPlus => plan != SubscriptionPlan.free;
  bool get isExpired =>
      expiresAt != null && expiresAt!.isBefore(DateTime.now());
  bool get isActive => isPlus && !isExpired;

  SubscriptionState copyWith({
    SubscriptionPlan? plan,
    DateTime? expiresAt,
    bool? isLoading,
  }) =>
      SubscriptionState(
        plan: plan ?? this.plan,
        expiresAt: expiresAt ?? this.expiresAt,
        isLoading: isLoading ?? this.isLoading,
      );
}

/// مزود الاشتراك
class SubscriptionNotifier extends StateNotifier<SubscriptionState> {
  SubscriptionNotifier() : super(const SubscriptionState());

  /// ترقية الاشتراك (وهمي مبدئياً — سيُربط مع Apple/Google IAP)
  Future<bool> subscribe(SubscriptionPlan plan) async {
    state = state.copyWith(isLoading: true);
    try {
      // TODO: استبدال بـ RevenueCat / StoreKit
      await Future.delayed(const Duration(seconds: 2));

      final duration = plan == SubscriptionPlan.yearlyPlus
          ? const Duration(days: 365)
          : const Duration(days: 30);

      state = SubscriptionState(
        plan: plan,
        expiresAt: DateTime.now().add(duration),
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  /// إلغاء الاشتراك
  void cancel() {
    state = const SubscriptionState();
  }

  /// تحميل حالة الاشتراك من السيرفر
  Future<void> loadFromServer() async {
    // TODO: API call
    state = const SubscriptionState(plan: SubscriptionPlan.free);
  }
}

final subscriptionProvider =
    StateNotifierProvider<SubscriptionNotifier, SubscriptionState>(
  (ref) => SubscriptionNotifier(),
);

/// هل المستخدم مشترك؟
final isPlusProvider = Provider<bool>((ref) {
  return ref.watch(subscriptionProvider).isActive;
});
