/// Riverpod providers للـ wearable — الـ UI يستدعي هذه فقط
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/device_info.dart';
import '../models/wearable_reading.dart';
import '../wearable_service.dart';

// ─── WearableService provider ───
final wearableServiceProvider = Provider<WearableService>((ref) {
  // في بيئة التطوير نستخدم StubConnector
  const isDev = bool.fromEnvironment('STUB_WEARABLE', defaultValue: true);
  return WearableService(useStubbedData: isDev);
});

// ─── حالة المزامنة ───

class WearableSyncState {
  final bool isSyncing;
  final List<SyncResult> lastResults;
  final DateTime? lastSyncAt;
  final String? error;

  const WearableSyncState({
    this.isSyncing = false,
    this.lastResults = const [],
    this.lastSyncAt,
    this.error,
  });

  WearableSyncState copyWith({
    bool? isSyncing,
    List<SyncResult>? lastResults,
    DateTime? lastSyncAt,
    String? error,
  }) => WearableSyncState(
    isSyncing: isSyncing ?? this.isSyncing,
    lastResults: lastResults ?? this.lastResults,
    lastSyncAt: lastSyncAt ?? this.lastSyncAt,
    error: error,
  );

  int get totalReadingsSynced =>
      lastResults.fold(0, (sum, r) => sum + r.readingsCount);
  bool get hasError => error != null;
  bool get allSucceeded => lastResults.every((r) => r.success);
}

// ─── Notifier للمزامنة ───

final wearableSyncProvider =
    AsyncNotifierProvider<WearableSyncNotifier, WearableSyncState>(
  WearableSyncNotifier.new,
);

class WearableSyncNotifier extends AsyncNotifier<WearableSyncState> {
  @override
  Future<WearableSyncState> build() async => const WearableSyncState();

  Future<void> syncNow(String patientId) async {
    state = AsyncData(
      (state.valueOrNull ?? const WearableSyncState())
          .copyWith(isSyncing: true, error: null),
    );

    try {
      final service = ref.read(wearableServiceProvider);
      final results = await service.syncAll(
        patientId: patientId,
        types: [
          WearableReadingType.bloodGlucose,
          WearableReadingType.bloodPressure,
          WearableReadingType.heartRate,
        ],
      );

      state = AsyncData(WearableSyncState(
        lastResults: results,
        lastSyncAt: DateTime.now(),
      ));
    } catch (e) {
      state = AsyncData(WearableSyncState(
        error: e.toString(),
      ));
    }
  }
}
