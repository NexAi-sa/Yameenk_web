library;

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';

abstract class PatientRemoteDataSource {
  Future<Map<String, dynamic>> getPatient(String patientId);
}

class PatientRemoteDataSourceImpl implements PatientRemoteDataSource {
  final DioClient _client;
  PatientRemoteDataSourceImpl(this._client);

  @override
  Future<Map<String, dynamic>> getPatient(String patientId) async {
    try {
      final res = await _client.rest.get('/patients/$patientId');
      return res.data as Map<String, dynamic>;
    } catch (_) {
      throw const ServerException();
    }
  }
}
