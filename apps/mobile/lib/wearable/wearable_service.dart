/// الخدمة المركزية — الـ UI يتعامل معها فقط
/// تختار الـ connector الصح، تنسّق، وتخزّن
library;

import 'abstractions/wearable_connector.dart';
import 'connectors/health_platform_connector.dart';
import 'connectors/stub_connector.dart';
import 'models/device_info.dart';
import 'models/wearable_reading.dart';

class WearableService {
  final List<DeviceInfo> _registeredDevices = [];

  /// الـ connectors المتاحة — تُضاف حسب الجهاز والمنصة
  late final List<WearableConnector> _connectors;

  WearableService({bool useStubbedData = false}) {
    _connectors = [
      if (useStubbedData) StubWearableConnector(),
      HealthPlatformConnector(),
      // BleWearableConnector يُضاف ديناميكياً عند إضافة جهاز
    ];
  }

  /// الأجهزة المسجّلة
  List<DeviceInfo> get registeredDevices =>
      List.unmodifiable(_registeredDevices);

  /// تسجيل جهاز جديد
  Future<bool> registerDevice(DeviceInfo device) async {
    if (_registeredDevices.any((d) => d.id == device.id)) return false;
    _registeredDevices.add(device);
    // TODO: حفظ في Hive
    // await _box.put(device.id, device.toJson());
    return true;
  }

  /// إزالة جهاز
  Future<void> removeDevice(String deviceId) async {
    _registeredDevices.removeWhere((d) => d.id == deviceId);
    // TODO: حذف من Hive
  }

  /// مزامنة كل الأجهزة النشطة
  Future<List<SyncResult>> syncAll({
    required String patientId,
    required List<WearableReadingType> types,
  }) async {
    final results = <SyncResult>[];
    for (final connector in _connectors) {
      try {
        if (await connector.isAvailable()) {
          final result = await connector.sync(
            patientId: patientId,
            types: types,
          );
          results.add(result);
        }
      } catch (e) {
        results.add(SyncResult(
          success: false,
          readingsCount: 0,
          syncedAt: DateTime.now(),
          deviceId: connector.connectorName,
          error: e.toString(),
        ));
      }
    }
    return results;
  }

  /// جلب كل القراءات من كل المصادر (دون حفظ)
  Future<List<WearableReading>> fetchAll({
    required String patientId,
    required List<WearableReadingType> types,
    required DateTime from,
  }) async {
    final allReadings = <WearableReading>[];
    for (final connector in _connectors) {
      try {
        if (await connector.isAvailable()) {
          final readings = await connector.fetchReadings(
            patientId: patientId,
            types: types,
            from: from,
          );
          allReadings.addAll(readings);
        }
      } catch (_) {
        // connector فشل — نكمل مع البقية
      }
    }
    // ترتيب حسب الوقت
    allReadings.sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
    return allReadings;
  }
}
