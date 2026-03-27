library;

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';

/// Contract for remote services operations.
abstract class ServicesRemoteDataSource {
  /// Fetches all available health services.
  Future<List<dynamic>> getServices();
}

class ServicesRemoteDataSourceImpl implements ServicesRemoteDataSource {
  final DioClient _client;
  ServicesRemoteDataSourceImpl(this._client);

  @override
  Future<List<dynamic>> getServices() async {
    try {
      final res = await _client.rest.get('/services');
      return res.data as List<dynamic>;
    } catch (_) {
      throw const ServerException();
    }
  }
}
