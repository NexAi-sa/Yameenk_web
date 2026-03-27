library;

import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final String patientId;
  final bool consentCompleted;

  const AuthAuthenticated({
    required this.patientId,
    required this.consentCompleted,
  });

  @override
  List<Object?> get props => [patientId, consentCompleted];
}

class AuthFailureState extends AuthState {
  final String message;
  const AuthFailureState(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthLoggedOut extends AuthState {
  const AuthLoggedOut();
}
