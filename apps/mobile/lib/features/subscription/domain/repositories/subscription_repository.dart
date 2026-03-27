library;

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../presentation/cubit/subscription_state.dart';

/// Contract for subscription repository.
abstract class SubscriptionRepository {
  /// Fetches the current subscription status.
  Future<Either<Failure, SubscriptionState>> getSubscription();

  /// Subscribes to a plan.
  Future<Either<Failure, SubscriptionState>> subscribe(SubscriptionPlan plan);
}
