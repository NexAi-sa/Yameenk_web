library;

import 'package:equatable/equatable.dart';

enum ReadingType { bloodSugar, bloodPressure, heartRate, oxygenSaturation }

enum ReadingSource { manual, wearable, healthPlatform }

class ReadingEntity extends Equatable {
  final String id;
  final String patientId;
  final ReadingType type;
  final double value;
  final double? value2;
  final String unit;
  final bool isNormal;
  final DateTime recordedAt;
  final ReadingSource source;
  final String? deviceName;

  const ReadingEntity({
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

  @override
  List<Object?> get props =>
      [id, patientId, type, value, value2, unit, isNormal, recordedAt, source];
}

class WeekSummaryEntity extends Equatable {
  final int total;
  final int normal;
  final int alerts;

  const WeekSummaryEntity({
    required this.total,
    required this.normal,
    required this.alerts,
  });

  @override
  List<Object> get props => [total, normal, alerts];
}
