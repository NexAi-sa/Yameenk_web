/// النموذج الموحّد لأي قراءة تأتي من أي جهاز
/// سواء كانت Apple Watch، Fitbit، Omron، أو Libre CGM
library;

enum ReadingSource {
  manual, // المستخدم أدخلها يدوياً
  appleHealth, // Apple HealthKit (iOS)
  googleHealth, // Google Health Connect (Android)
  bleDirect, // Bluetooth مباشر مع الجهاز
  cloudSync, // مزامنة من API خارجي (Fitbit/Garmin)
}

enum WearableReadingType {
  bloodGlucose, // السكر — mg/dL
  bloodPressure, // الضغط — mmHg (systolic/diastolic)
  heartRate, // معدل القلب — bpm
  oxygenSaturation, // تشبع الأكسجين — %
  steps, // خطوات
  weight, // وزن — kg
}

class WearableReading {
  final String id;
  final String patientId;
  final WearableReadingType type;
  final double value;
  final double? value2; // للضغط: diastolic
  final String unit;
  final DateTime recordedAt; // وقت القياس الفعلي من الجهاز
  final DateTime syncedAt; // وقت وصولها للتطبيق
  final ReadingSource source;
  final String? deviceName; // "Apple Watch Series 9"
  final String? deviceId; // MAC address أو device UUID
  final Map<String, dynamic>? metadata; // بيانات إضافية حسب الجهاز

  const WearableReading({
    required this.id,
    required this.patientId,
    required this.type,
    required this.value,
    this.value2,
    required this.unit,
    required this.recordedAt,
    required this.syncedAt,
    required this.source,
    this.deviceName,
    this.deviceId,
    this.metadata,
  });

  /// تحويل للـ HealthReading JSON — حتى لا تتغير بقية الكود
  Map<String, dynamic> toReadingJson() => {
    'id': id,
    'patient_id': patientId,
    'type': _typeToApiString(),
    'value': value,
    if (value2 != null) 'value2': value2,
    'unit': unit,
    'recorded_at': recordedAt.toIso8601String(),
    'source': source.name,
    'device_name': deviceName,
    'is_normal': null, // يحسبها الباك إند
  };

  String _typeToApiString() => switch (type) {
    WearableReadingType.bloodGlucose => 'blood_sugar',
    WearableReadingType.bloodPressure => 'blood_pressure',
    WearableReadingType.heartRate => 'heart_rate',
    WearableReadingType.oxygenSaturation => 'oxygen_saturation',
    WearableReadingType.steps => 'steps',
    WearableReadingType.weight => 'weight',
  };

  String get sourceLabel => switch (source) {
    ReadingSource.manual => 'يدوي',
    ReadingSource.appleHealth => 'Apple Health',
    ReadingSource.googleHealth => 'Google Health',
    ReadingSource.bleDirect => deviceName ?? 'جهاز Bluetooth',
    ReadingSource.cloudSync => deviceName ?? 'جهاز ذكي',
  };
}
