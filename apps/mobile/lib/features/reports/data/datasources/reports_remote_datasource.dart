library;

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';

/// Contract for remote reports operations.
abstract class ReportsRemoteDataSource {
  /// Fetches all health reports for [patientId].
  Future<List<dynamic>> getReports(String patientId);

  /// Triggers server-side report generation for [patientId].
  Future<Map<String, dynamic>> generateReport(String patientId);
}

class ReportsRemoteDataSourceImpl implements ReportsRemoteDataSource {
  final DioClient _client;
  ReportsRemoteDataSourceImpl(this._client);

  @override
  Future<List<dynamic>> getReports(String patientId) async {
    try {
      final res = await _client.rest.get(
        '/reports',
        queryParameters: {
          'patient_id': 'eq.$patientId',
          'order': 'generated_at.desc',
        },
      );
      return res.data as List<dynamic>;
    } catch (_) {
      throw const ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> generateReport(String patientId) async {
    try {
      final res = await _client.functions.post(
        '/generate-report',
        data: {'patient_id': patientId},
      );
      return res.data as Map<String, dynamic>;
    } catch (_) {
      throw const ServerException();
    }
  }
}
