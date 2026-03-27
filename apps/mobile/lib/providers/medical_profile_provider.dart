import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/medical_profile.dart';
import '../services/api_service.dart';
import '../providers/auth_provider.dart';

/// مفتاح التخزين المحلي
const _cacheKey = 'medical_profile_cache';

/// حالة معالج إعداد الملف الطبي
class ProfileSetupState {
  final int currentStep;
  final MedicalProfile profile;
  final bool isSaving;

  const ProfileSetupState({
    this.currentStep = 0,
    required this.profile,
    this.isSaving = false,
  });

  ProfileSetupState copyWith({
    int? currentStep,
    MedicalProfile? profile,
    bool? isSaving,
  }) =>
      ProfileSetupState(
        currentStep: currentStep ?? this.currentStep,
        profile: profile ?? this.profile,
        isSaving: isSaving ?? this.isSaving,
      );
}

/// Provider — الملف الطبي (Local-first + Supabase sync)
final medicalProfileProvider =
    StateNotifierProvider<MedicalProfileNotifier, AsyncValue<MedicalProfile>>(
        (ref) => MedicalProfileNotifier(ref));

class MedicalProfileNotifier extends StateNotifier<AsyncValue<MedicalProfile>> {
  final Ref _ref;

  MedicalProfileNotifier(this._ref) : super(const AsyncValue.loading()) {
    load();
  }

  /// 1) يقرأ من cache محلي (فوري) ← 2) يُحدّث من Supabase (في الخلفية)
  Future<void> load() async {
    state = const AsyncValue.loading();

    try {
      // ─── خطوة 1: قراءة cache محلي ───
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString(_cacheKey);
      if (cached != null && cached.isNotEmpty) {
        final profile = MedicalProfile.fromJson(
          jsonDecode(cached) as Map<String, dynamic>,
        );
        state = AsyncValue.data(profile);
      }

      // ─── خطوة 2: تحديث من Supabase ───
      final patientId = _ref.read(authProvider).patientId;
      if (patientId.isEmpty) {
        // المستخدم لم يسجل دخول بعد — نُبقي الـ cache أو فارغ
        if (!state.hasValue) {
          state = AsyncValue.data(MedicalProfile.empty(''));
        }
        return;
      }

      final api = _ref.read(apiServiceProvider);
      final data = await api.getMedicalProfile(patientId);

      final profile = MedicalProfile.fromSupabase(
        data['patient'] as Map<String, dynamic>,
        medications: data['medications'] as List?,
        emergencyContacts: data['emergency_contacts'] as List?,
        notifPrefs: data['notification_preferences'] as Map<String, dynamic>?,
      );

      // حفظ في cache + تحديث state
      await _saveToCache(prefs, profile);
      state = AsyncValue.data(profile);
    } catch (e, st) {
      // إذا فيه cache قديم — نستخدمه. وإلا error
      if (!state.hasValue) {
        state = AsyncValue.error(e, st);
      }
      // لو فيه cache → نُبقيه ونتجاهل خطأ الشبكة
    }
  }

  /// حفظ الملف الطبي: محلي فوراً + Supabase في الخلفية
  Future<void> save(MedicalProfile profile) async {
    // حفظ محلي فوري
    final prefs = await SharedPreferences.getInstance();
    await _saveToCache(prefs, profile);
    state = AsyncValue.data(profile);

    // مزامنة مع Supabase
    try {
      final api = _ref.read(apiServiceProvider);
      final patientId = profile.patientId;

      // تحديث بيانات المريض الأساسية
      await api.updatePatient(patientId, {
        'full_name': profile.fullName,
        'blood_type': profile.bloodType,
        'gender': profile.gender,
        'height': profile.height,
        'weight': profile.weight,
        'chronic_conditions':
            profile.diseases.map((d) => d.name).toList(),
        'allergies':
            profile.allergies.map((a) => a.name).toList(),
      });

      // الأدوية
      await api.upsertMedications(
        patientId,
        profile.medications.map((m) => m.toJson()).toList(),
      );

      // جهات الطوارئ
      await api.upsertEmergencyContacts(
        patientId,
        profile.emergencyContacts.map((c) => c.toJson()).toList(),
      );

      // تفضيلات الإشعارات
      await api.upsertNotificationPreferences(
        patientId,
        profile.notificationPreferences.toJson(),
      );
    } catch (_) {
      // الحفظ المحلي نجح — السيرفر يتزامن لاحقاً
    }
  }

  Future<void> _saveToCache(SharedPreferences prefs, MedicalProfile profile) async {
    await prefs.setString(_cacheKey, jsonEncode(profile.toJson()));
  }
}

/// Provider — معالج إعداد الملف
final profileSetupProvider =
    StateNotifierProvider<ProfileSetupNotifier, ProfileSetupState>(
  (ref) => ProfileSetupNotifier(ref),
);

class ProfileSetupNotifier extends StateNotifier<ProfileSetupState> {
  final Ref _ref;

  ProfileSetupNotifier(this._ref)
      : super(ProfileSetupState(profile: MedicalProfile.empty(''))) {
    // تحميل patientId من auth
    final patientId = _ref.read(authProvider).patientId;
    if (patientId.isNotEmpty) {
      state = ProfileSetupState(profile: MedicalProfile.empty(patientId));
    }
  }

  void updateProfile(MedicalProfile profile) {
    state = state.copyWith(profile: profile);
  }

  void nextStep() {
    if (state.currentStep < 3) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void goToStep(int step) {
    state = state.copyWith(currentStep: step.clamp(0, 3));
  }

  Future<void> submit() async {
    state = state.copyWith(isSaving: true);
    await _ref.read(medicalProfileProvider.notifier).save(state.profile);
    state = state.copyWith(isSaving: false);
  }
}
