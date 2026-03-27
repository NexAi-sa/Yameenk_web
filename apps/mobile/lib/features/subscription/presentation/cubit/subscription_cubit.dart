library;

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/subscription_repository.dart';
import 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  final SubscriptionRepository _repository;

  SubscriptionCubit({required SubscriptionRepository repository})
      : _repository = repository,
        super(const SubscriptionState());

  Future<bool> subscribe(SubscriptionPlan plan) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.subscribe(plan);
    return result.fold(
      (failure) {
        emit(state.copyWith(
            isLoading: false, errorMessage: failure.message));
        return false;
      },
      (newState) {
        emit(newState);
        return true;
      },
    );
  }

  void cancel() => emit(const SubscriptionState());

  Future<void> loadFromServer() async {
    final result = await _repository.getSubscription();
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (serverState) => emit(serverState),
    );
  }
}
