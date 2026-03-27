import '../wearable/models/wearable_reading.dart';

enum ReadingType { bloodSugar, bloodPressure, heartRate, oxygenSaturation }

class HealthReading {
  final String id;
  final String patientId;
  final ReadingType type;
  final double value;
  final double? value2; // الضغط السفلي
  final String unit;
  final bool isNormal;
  final DateTime recordedAt;
  final ReadingSource source;
  final String? deviceName;

  const HealthReading({
    required this.id,
    required this.patientId,
    required this.type,
    required this.value,
    this.value2,
    required this.unit,
    required this.isNormal,
    required this.recordedAt,
    this.source = ReadingSource.manual,
    this.deviceName,
  });

  String get displayValue {
    if (type == ReadingType.bloodPressure && value2 != null) {
      return '${value.toInt()}/${value2!.toInt()}';
    }
    return value.toInt().toString();
  }

  factory HealthReading.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String? ?? '';
    final type = switch (typeStr) {
      'blood_sugar' => ReadingType.bloodSugar,
      'blood_pressure' => ReadingType.bloodPressure,
      'heart_rate' => ReadingType.heartRate,
      'oxygen_saturation' => ReadingType.oxygenSaturation,
      _ => ReadingType.bloodSugar,
    };

    return HealthReading(
      id: json['id'] as String,
      patientId: json['patient_id'] as String,
      type: type,
      value: (json['value'] as num).toDouble(),
      value2: json['value2'] != null ? (json['value2'] as num).toDouble() : null,
      unit: json['unit'] as String,
      isNormal: json['is_normal'] as bool? ?? true,
      recordedAt: DateTime.parse(json['recorded_at'] as String),
      source: ReadingSource.values.byName(
        json['source'] as String? ?? 'manual',
      ),
      deviceName: json['device_name'] as String?,
    );
  }
}

class WeekSummary {
  final int total;
  final int normal;
  final int alerts;

  const WeekSummary({
    required this.total,
    required this.normal,
    required this.alerts,
  });
}
