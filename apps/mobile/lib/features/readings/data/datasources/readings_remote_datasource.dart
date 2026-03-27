library;

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';

abstract class ReadingsRemoteDataSource {
  Future<List<dynamic>> getReadings(String patientId, {int days = 7});
  Future<void> recordReading({
    required String patientId,
    required String type,
    double? value,
    int? systolic,
    int? diastolic,
    String? context,
  });
}

class ReadingsRemoteDataSourceImpl implements ReadingsRemoteDataSource {
  final DioClient _client;
  ReadingsRemoteDataSourceImpl(this._client);

  @override
  Future<List<dynamic>> getReadings(String patientId,
      {int days = 7}) async {
    try {
      final res = await _client.rest.get('/readings', queryParameters: {
        'patient_id': patientId,
        'days': days,
      });
      return res.data as List<dynamic>;
    } catch (_) {
      throw const ServerException();
    }
  }

  @override
  Future<void> recordReading({
    required String patientId,
    required String type,
    double? value,
    int? systolic,
    int? diastolic,
    String? context,
  }) async {
    try {
      await _client.rest.post('/readings', data: {
        'patient_id': patientId,
        'type': type,
        if (value != null) 'value_1': value,
        if (systolic != null) 'value_1': systolic,
        if (diastolic != null) 'value_2': diastolic,
        if (context != null) 'context': context,
      });
    } catch (_) {
      throw const ServerException();
    }
  }
}
