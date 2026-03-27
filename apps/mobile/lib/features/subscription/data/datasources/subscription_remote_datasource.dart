library;

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';

/// Contract for remote subscription operations.
abstract class SubscriptionRemoteDataSource {
  /// Fetches the current subscription status.
  Future<Map<String, dynamic>> getSubscription();

  /// Subscribes to a plan.
  Future<Map<String, dynamic>> subscribe(String planId);
}

class SubscriptionRemoteDataSourceImpl
    implements SubscriptionRemoteDataSource {
  final DioClient _client;
  SubscriptionRemoteDataSourceImpl(this._client);

  @override
  Future<Map<String, dynamic>> getSubscription() async {
    try {
      final res = await _client.rest.get('/subscriptions/current');
      return res.data as Map<String, dynamic>;
    } catch (_) {
      throw const ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> subscribe(String planId) async {
    try {
      final res = await _client.rest.post(
        '/subscriptions',
        data: {'plan_id': planId},
      );
      return res.data as Map<String, dynamic>;
    } catch (_) {
      throw const ServerException();
    }
  }
}
