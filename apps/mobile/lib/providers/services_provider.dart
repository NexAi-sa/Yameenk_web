import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/health_service.dart';

/// Provider — قائمة الخدمات الصحية
final healthServicesProvider = StateNotifierProvider<HealthServicesNotifier,
    AsyncValue<List<HealthService>>>((ref) => HealthServicesNotifier());

/// Provider — التصنيف المختار
final selectedCategoryProvider = StateProvider<String>((ref) => 'الكل');

/// Provider — الخدمات المفلترة
final filteredServicesProvider =
    Provider<AsyncValue<List<HealthService>>>((ref) {
  final category = ref.watch(selectedCategoryProvider);
  final servicesAsync = ref.watch(healthServicesProvider);

  return servicesAsync.whenData((services) {
    if (category == 'الكل') return services;
    return services.where((s) => s.category == category).toList();
  });
});

class HealthServicesNotifier
    extends StateNotifier<AsyncValue<List<HealthService>>> {
  HealthServicesNotifier() : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    // TODO: استبدال بـ API call حقيقي
    await Future.delayed(const Duration(milliseconds: 500));
    state = AsyncValue.data(HealthService.mockList());
  }
}
