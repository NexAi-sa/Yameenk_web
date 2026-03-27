import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/health_report.dart';

/// Provider — التقارير الصحية
final healthReportsProvider = StateNotifierProvider<HealthReportsNotifier,
    AsyncValue<List<HealthReport>>>((ref) => HealthReportsNotifier());

class HealthReportsNotifier
    extends StateNotifier<AsyncValue<List<HealthReport>>> {
  HealthReportsNotifier() : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    // TODO: استبدال بـ API call حقيقي
    await Future.delayed(const Duration(milliseconds: 500));
    state = AsyncValue.data(HealthReport.mockList());
  }
}
