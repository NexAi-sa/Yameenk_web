/// الـ interface الموحّد — كل connector يُنفّذه بغض النظر عن المصدر
/// هذا هو قلب البنية التحتية
library;

import '../models/device_info.dart';
import '../models/wearable_reading.dart';

abstract class WearableConnector {
  /// اسم المصدر للـ logging
  String get connectorName;

  /// هل المصدر متاح على هذا الجهاز؟
  /// HealthKit متاح على iOS فقط، Health Connect على Android
  Future<bool> isAvailable();

  /// طلب إذن الوصول من المستخدم — تُنفَّذ مرة واحدة فقط
  Future<bool> requestPermissions(List<WearableReadingType> types);

  /// هل تم منح الأذونات مسبقاً؟
  Future<bool> hasPermissions(List<WearableReadingType> types);

  /// جلب القراءات من فترة زمنية محددة
  Future<List<WearableReading>> fetchReadings({
    required String patientId,
    required List<WearableReadingType> types,
    required DateTime from,
    DateTime? to,
  });

  /// مزامنة فورية وحفظ للـ backend
  Future<SyncResult> sync({
    required String patientId,
    required List<WearableReadingType> types,
  });

  /// استماع للقراءات اللحظية (للـ BLE فقط)
  /// غير مطلوب للـ HealthKit/Health Connect
  Stream<WearableReading>? get liveStream => null;

  /// قطع الاتصال (للـ BLE)
  Future<void> disconnect() async {}
}
