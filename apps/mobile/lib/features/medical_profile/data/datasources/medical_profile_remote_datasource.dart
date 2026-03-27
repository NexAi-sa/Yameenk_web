library;

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/medical_profile_model.dart';

abstract class MedicalProfileDataSource {
  Future<MedicalProfileModel> getMedicalProfile(String patientId);
  Future<void> saveMedicalProfile(MedicalProfileModel profile);
  Future<MedicalProfileModel?> getCachedProfile();
  Future<void> cacheProfile(MedicalProfileModel profile);
}

class MedicalProfileDataSourceImpl implements MedicalProfileDataSource {
  final DioClient _client;
  static const _cacheKey = 'medical_profile_cache';

  MedicalProfileDataSourceImpl(this._client);

  @override
  Future<MedicalProfileModel> getMedicalProfile(String patientId) async {
    try {
      final results = await Future.wait([
        _client.rest.get('/patients', queryParameters: {
          'id': 'eq.$patientId',
          'select': '*',
        }),
        _client.rest.get('/medications', queryParameters: {
          'patient_id': 'eq.$patientId',
          'is_active': 'eq.true',
          'select': 'name,dosage,frequency,notes',
        }),
        _client.rest.get('/emergency_contacts', queryParameters: {
          'patient_id': 'eq.$patientId',
          'select': 'name,phone,relation',
        }),
        _client.rest.get('/notification_preferences', queryParameters: {
          'patient_id': 'eq.$patientId',
          'select': '*',
        }),
      ]);

      final patients = results[0].data as List;
      if (patients.isEmpty) throw const NotFoundException('المريض غير موجود');

      return MedicalProfileModel.fromSupabase(
        patients.first as Map<String, dynamic>,
        medications: results[1].data as List?,
        emergencyContacts: results[2].data as List?,
        notifPrefs: (results[3].data as List).isNotEmpty
            ? (results[3].data as List).first as Map<String, dynamic>
            : null,
      );
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw const ServerException();
    }
  }

  @override
  Future<void> saveMedicalProfile(MedicalProfileModel profile) async {
    try {
      final patientId = profile.patientId;
      await Future.wait([
        _client.rest.patch(
          '/patients?id=eq.$patientId',
          data: {
            'full_name': profile.fullName,
            'blood_type': profile.bloodType,
            'gender': profile.gender,
            'height': profile.height,
            'weight': profile.weight,
            'chronic_conditions':
                profile.diseases.map((d) => d.name).toList(),
            'allergies': profile.allergies.map((a) => a.name).toList(),
          },
        ),
        _upsertMedications(patientId, profile.medications
            .map((m) => {
                  'name': m.name,
                  'dosage': m.dosage,
                  'frequency': m.frequency,
                  if (m.notes != null) 'notes': m.notes,
                })
            .toList()),
        _upsertEmergencyContacts(patientId, profile.emergencyContacts
            .map((c) =>
                {'name': c.name, 'phone': c.phone, 'relation': c.relation})
            .toList()),
      ]);
    } catch (_) {
      throw const ServerException();
    }
  }

  Future<void> _upsertMedications(
      String patientId, List<Map<String, dynamic>> meds) async {
    await _client.rest.patch(
      '/medications?patient_id=eq.$patientId&is_active=eq.true',
      data: {'is_active': false},
    );
    if (meds.isNotEmpty) {
      await _client.rest.post(
        '/medications',
        data: meds.map((m) => {...m, 'patient_id': patientId}).toList(),
      );
    }
  }

  Future<void> _upsertEmergencyContacts(
      String patientId, List<Map<String, dynamic>> contacts) async {
    await _client.rest
        .delete('/emergency_contacts?patient_id=eq.$patientId');
    if (contacts.isNotEmpty) {
      await _client.rest.post(
        '/emergency_contacts',
        data: contacts.map((c) => {...c, 'patient_id': patientId}).toList(),
      );
    }
  }

  @override
  Future<MedicalProfileModel?> getCachedProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString(_cacheKey);
      if (cached == null || cached.isEmpty) return null;
      return MedicalProfileModel.fromJson(
          jsonDecode(cached) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheProfile(MedicalProfileModel profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cacheKey, profile.toJsonString());
  }
}
