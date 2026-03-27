library;

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';

abstract class ChatRemoteDataSource {
  Future<String> sendMessage(String patientId, String message);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final DioClient _client;
  ChatRemoteDataSourceImpl(this._client);

  @override
  Future<String> sendMessage(String patientId, String message) async {
    try {
      final res = await _client.functions.post('/chat', data: {
        'patient_id': patientId,
        'message': message,
      });
      return (res.data as Map<String, dynamic>)['response'] as String;
    } catch (_) {
      throw const ServerException('فشل إرسال الرسالة');
    }
  }
}
