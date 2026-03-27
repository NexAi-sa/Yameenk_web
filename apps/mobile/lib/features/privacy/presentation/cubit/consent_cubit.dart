library;

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/consent_entity.dart';
import '../../domain/repositories/consent_repository.dart';
import 'consent_state.dart';

class ConsentCubit extends Cubit<ConsentState> {
  final ConsentRepository _repository;

  ConsentCubit({required ConsentRepository repository})
      : _repository = repository,
        super(const ConsentInitial()) {
    _init();
  }

  Future<void> _init() async {
    final result = await _repository.hasCompletedConsent();
    result.fold(
      (_) => emit(const ConsentLoaded(ConsentEntity())),
      (completed) => emit(ConsentLoaded(
          ConsentEntity(hasCompletedInitialConsent: completed))),
    );
  }

  void toggle(ConsentType type, bool value) {
    if (state is! ConsentLoaded) return;
    final current = (state as ConsentLoaded).consent;
    final updated = Map<ConsentType, bool>.from(current.consents)
      ..[type] = value;
    emit(ConsentLoaded(current.copyWith(consents: updated)));
  }

  Future<bool> submit() async {
    if (state is! ConsentLoaded) return false;
    final consent = (state as ConsentLoaded).consent;
    emit(const ConsentSubmitting());

    final result = await _repository.submitConsents(consent.consents);

    return result.fold(
      (failure) {
        emit(ConsentError(failure.message));
        return false;
      },
      (_) {
        emit(const ConsentSubmitted());
        return true;
      },
    );
  }

  Future<void> loadFromServer() async {
    emit(const ConsentLoading());
    final result = await _repository.getConsents();
    result.fold(
      (failure) => emit(ConsentError(failure.message)),
      (serverConsents) {
        final Map<ConsentType, bool> loaded = {};
        for (final c in serverConsents) {
          final type = ConsentType.values.cast<ConsentType?>().firstWhere(
                (t) => t?.apiKey == c['consent_type'],
                orElse: () => null,
              );
          if (type != null) loaded[type] = c['granted'] == true;
        }
        emit(ConsentLoaded(ConsentEntity(
          consents: loaded,
          hasCompletedInitialConsent: true,
        )));
      },
    );
  }

  Future<void> revoke(ConsentType type) async {
    await _repository.revokeConsent(type);
    if (state is ConsentLoaded) {
      final current = (state as ConsentLoaded).consent;
      final updated = Map<ConsentType, bool>.from(current.consents)
        ..[type] = false;
      emit(ConsentLoaded(current.copyWith(consents: updated)));
    }
  }
}
