import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/patient.dart';
import '../models/reading.dart';
import '../services/api_service.dart';
import 'auth_provider.dart';

final patientProvider = FutureProvider<Patient>((ref) async {
  final patientId = await ref.watch(currentPatientIdProvider.future);
  final api = ref.watch(apiServiceProvider);
  final json = await api.getPatient(patientId);
  return Patient.fromJson(json);
});

final weekReadingsProvider = FutureProvider<List<HealthReading>>((ref) async {
  final patientId = await ref.watch(currentPatientIdProvider.future);
  final api = ref.watch(apiServiceProvider);
  final data = await api.getReadings(patientId, days: 7);
  return data
      .map((e) => HealthReading.fromJson(e as Map<String, dynamic>))
      .toList();
});

final weekSummaryProvider = Provider<AsyncValue<WeekSummary>>((ref) {
  return ref.watch(weekReadingsProvider).whenData((readings) {
    final normal = readings.where((r) => r.isNormal).length;
    return WeekSummary(
      total: readings.length,
      normal: normal,
      alerts: readings.length - normal,
    );
  });
});
