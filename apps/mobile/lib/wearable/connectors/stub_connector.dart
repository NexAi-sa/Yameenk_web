/// Connector وهمي للتطوير والاختبار
/// لا يحتاج أي permission، لا يفتح BLE، لا يتصل بأي API
library;

import '../abstractions/wearable_connector.dart';
import '../models/device_info.dart';
import '../models/wearable_reading.dart';

class StubWearableConnector implements WearableConnector {
  @override
  String get connectorName => 'Stub (Development)';

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<bool> requestPermissions(List<WearableReadingType> types) async =>
      true;

  @override
  Future<bool> hasPermissions(List<WearableReadingType> types) async => true;

  @override
  Future<List<WearableReading>> fetchReadings({
    required String patientId,
    required List<WearableReadingType> types,
    required DateTime from,
    DateTime? to,
  }) async {
    await Future.delayed(
        const Duration(milliseconds: 600)); // simulate latency

    final now = DateTime.now();
    return [
      WearableReading(
        id: 'stub_${now.millisecondsSinceEpoch}_1',
        patientId: patientId,
        type: WearableReadingType.bloodGlucose,
        value: 118,
        unit: 'mg/dL',
        recordedAt: now.subtract(const Duration(minutes: 5)),
        syncedAt: now,
        source: ReadingSource.appleHealth,
        deviceName: 'Stub Apple Watch',
      ),
      WearableReading(
        id: 'stub_${now.millisecondsSinceEpoch}_2',
        patientId: patientId,
        type: WearableReadingType.bloodPressure,
        value: 122,
        value2: 78,
        unit: 'mmHg',
        recordedAt: now.subtract(const Duration(hours: 2)),
        syncedAt: now,
        source: ReadingSource.bleDirect,
        deviceName: 'Stub Omron M7',
      ),
    ];
  }

  @override
  Future<SyncResult> sync({
    required String patientId,
    required List<WearableReadingType> types,
  }) async {
    final readings = await fetchReadings(
      patientId: patientId,
      types: types,
      from: DateTime.now().subtract(const Duration(hours: 24)),
    );
    return SyncResult(
      success: true,
      readingsCount: readings.length,
      syncedAt: DateTime.now(),
      deviceId: 'stub_device',
    );
  }

  @override
  Stream<WearableReading>? get liveStream => null;

  @override
  Future<void> disconnect() async {}
}
