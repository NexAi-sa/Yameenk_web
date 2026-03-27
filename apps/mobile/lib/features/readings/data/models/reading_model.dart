library;

import '../../domain/entities/reading_entity.dart';

class ReadingModel extends ReadingEntity {
  const ReadingModel({
    required super.id,
    required super.patientId,
    required super.type,
    required super.value,
    super.value2,
    required super.unit,
    required super.isNormal,
    required super.recordedAt,
    super.source = ReadingSource.manual,
    super.deviceName,
  });

  factory ReadingModel.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String? ?? '';
    final type = switch (typeStr) {
      'blood_sugar' => ReadingType.bloodSugar,
      'blood_pressure' => ReadingType.bloodPressure,
      'heart_rate' => ReadingType.heartRate,
      'oxygen_saturation' => ReadingType.oxygenSaturation,
      _ => ReadingType.bloodSugar,
    };

    ReadingSource source = ReadingSource.manual;
    final sourceStr = json['source'] as String?;
    if (sourceStr != null) {
      source = ReadingSource.values.firstWhere(
        (s) => s.name == sourceStr,
        orElse: () => ReadingSource.manual,
      );
    }

    return ReadingModel(
      id: json['id'] as String,
      patientId: json['patient_id'] as String,
      type: type,
      value: (json['value_1'] as num).toDouble(),
      value2: json['value_2'] != null
          ? (json['value_2'] as num).toDouble()
          : null,
      unit: json['unit'] as String,
      isNormal: json['is_normal'] as bool? ?? true,
      recordedAt: DateTime.parse(json['recorded_at'] as String),
      source: source,
      deviceName: json['device_name'] as String?,
    );
  }
}
