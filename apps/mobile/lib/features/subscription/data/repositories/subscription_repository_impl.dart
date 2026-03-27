library;

import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../../presentation/cubit/subscription_state.dart';
import '../datasources/subscription_remote_datasource.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionRemoteDataSource _dataSource;
  SubscriptionRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, SubscriptionState>> getSubscription() async {
    try {
      final data = await _dataSource.getSubscription();
      return Right(_parseState(data));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, SubscriptionState>> subscribe(
      SubscriptionPlan plan) async {
    try {
      final planId = switch (plan) {
        SubscriptionPlan.monthlyPlus => 'monthly_plus',
        SubscriptionPlan.yearlyPlus => 'yearly_plus',
        SubscriptionPlan.free => 'free',
      };
      final data = await _dataSource.subscribe(planId);
      return Right(_parseState(data));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  SubscriptionState _parseState(Map<String, dynamic> data) {
    final planStr = data['plan'] as String? ?? 'free';
    final plan = switch (planStr) {
      'monthly_plus' => SubscriptionPlan.monthlyPlus,
      'yearly_plus' => SubscriptionPlan.yearlyPlus,
      _ => SubscriptionPlan.free,
    };
    final expiresAtStr = data['expires_at'] as String?;
    return SubscriptionState(
      plan: plan,
      expiresAt:
          expiresAtStr != null ? DateTime.tryParse(expiresAtStr) : null,
    );
  }
}
