/// Connector لـ Apple HealthKit (iOS) و Google Health Connect (Android)
/// يستخدم package:health — الأكثر نضجاً ودعماً حالياً
///
/// pubspec.yaml:
///   health: ^10.2.0   ← يدعم iOS HealthKit + Android Health Connect
library;

import '../abstractions/wearable_connector.dart';
import '../models/device_info.dart';
import '../models/wearable_reading.dart';

// import 'package:health/health.dart';  ← أضف عند الاستخدام الفعلي

class HealthPlatformConnector implements WearableConnector {
  // final HealthFactory _health = HealthFactory();  ← ألغِ التعليق عند التفعيل

  @override
  String get connectorName => 'Health Platform (HealthKit / Health Connect)';

  @override
  Future<bool> isAvailable() async {
    // return await Health().isHealthConnectAvailable(); // Android
    // iOS HealthKit دائماً متاح على الأجهزة الحقيقية
    // للآن نرجع false حتى يُضاف الـ package
    return false; // ← غيّر لـ true عند إضافة health package
  }

  @override
  Future<bool> requestPermissions(List<WearableReadingType> types) async {
    // final healthTypes = _mapTypes(types);
    // return await Health().requestAuthorization(healthTypes);
    throw UnimplementedError(
      'أضف package:health للـ pubspec.yaml أولاً\n'
      'health: ^10.2.0',
    );
  }

  @override
  Future<bool> hasPermissions(List<WearableReadingType> types) async {
    // final healthTypes = _mapTypes(types);
    // return await Health().hasPermissions(healthTypes) ?? false;
    return false;
  }

  @override
  Future<List<WearableReading>> fetchReadings({
    required String patientId,
    required List<WearableReadingType> types,
    required DateTime from,
    DateTime? to,
  }) async {
    // TODO: تفعيل عند إضافة package:health
    // final healthTypes = _mapTypes(types);
    // final dataPoints = await Health().getHealthDataFromTypes(
    //   startTime: from,
    //   endTime: to ?? DateTime.now(),
    //   types: healthTypes,
    // );
    // return dataPoints.map(_mapToWearableReading(patientId)).toList();
    return [];
  }

  @override
  Future<SyncResult> sync({
    required String patientId,
    required List<WearableReadingType> types,
  }) async {
    final readings = await fetchReadings(
      patientId: patientId,
      types: types,
      from: DateTime.now().subtract(const Duration(hours: 8)),
    );
    // TODO: إرسال للـ backend عبر ApiService
    return SyncResult(
      success: true,
      readingsCount: readings.length,
      syncedAt: DateTime.now(),
      deviceId: 'health_platform',
    );
  }

  @override
  Stream<WearableReading>? get liveStream => null;

  @override
  Future<void> disconnect() async {}

  // تحويل WearableReadingType لـ HealthDataType من package:health
  // List<HealthDataType> _mapTypes(List<WearableReadingType> types) {
  //   return types.map((t) => switch (t) {
  //     WearableReadingType.bloodGlucose => HealthDataType.BLOOD_GLUCOSE,
  //     WearableReadingType.bloodPressure =>
  //       HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
  //     WearableReadingType.heartRate => HealthDataType.HEART_RATE,
  //     WearableReadingType.oxygenSaturation => HealthDataType.BLOOD_OXYGEN,
  //     WearableReadingType.steps => HealthDataType.STEPS,
  //     WearableReadingType.weight => HealthDataType.WEIGHT,
  //   }).toList();
  // }
}
