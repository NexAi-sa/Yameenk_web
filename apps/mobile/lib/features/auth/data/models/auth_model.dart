library;

import '../../domain/entities/auth_entity.dart';

class AuthModel extends AuthEntity {
  const AuthModel({
    required super.patientId,
    required super.accessToken,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
        patientId: json['patient_id'] as String? ?? '',
        accessToken: json['access_token'] as String? ?? '',
      );
}
