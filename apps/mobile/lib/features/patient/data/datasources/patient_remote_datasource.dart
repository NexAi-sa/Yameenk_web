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
      final res = await _client.rest.get('/patients', queryParameters: {
        'id': 'eq.$patientId',
        'select': '*',
      });
      final list = res.data as List;
      if (list.isEmpty) {
        throw const ServerException('المريض غير موجود');
      }
      return list.first as Map<String, dynamic>;
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException();
    }
  }
}
