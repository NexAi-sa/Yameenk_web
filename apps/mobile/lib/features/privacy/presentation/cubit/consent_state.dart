library;

import 'package:equatable/equatable.dart';
import '../../domain/entities/consent_entity.dart';

abstract class ConsentState extends Equatable {
  const ConsentState();

  @override
  List<Object?> get props => [];
}

class ConsentInitial extends ConsentState {
  const ConsentInitial();
}

class ConsentLoading extends ConsentState {
  const ConsentLoading();
}

class ConsentLoaded extends ConsentState {
  final ConsentEntity consent;
  const ConsentLoaded(this.consent);

  @override
  List<Object?> get props => [consent];
}

class ConsentSubmitting extends ConsentState {
  const ConsentSubmitting();
}

class ConsentSubmitted extends ConsentState {
  const ConsentSubmitted();
}

class ConsentError extends ConsentState {
  final String message;
  const ConsentError(this.message);

  @override
  List<Object?> get props => [message];
}
