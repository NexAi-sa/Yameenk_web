library;

import '../../domain/entities/auth_entity.dart';

class AuthModel extends AuthEntity {
  const AuthModel({
    required super.patientId,
    required super.accessToken,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    // Supabase signup returns user ID at 'user.id', while OTP returns 'patient_id'
    final user = json['user'] as Map<String, dynamic>?;
    final patientId = json['patient_id'] as String?
        ?? user?['id'] as String?
        ?? '';
    return AuthModel(
      patientId: patientId,
      accessToken: json['access_token'] as String? ?? '',
    );
  }
}
