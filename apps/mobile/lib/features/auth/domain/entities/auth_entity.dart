library;

import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String patientId;
  final String accessToken;

  const AuthEntity({
    required this.patientId,
    required this.accessToken,
  });

  @override
  List<Object> get props => [patientId, accessToken];
}
