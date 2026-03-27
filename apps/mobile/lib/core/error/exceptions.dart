/// Custom exceptions thrown in the data layer.
/// These are caught by repository implementations and converted to Failures.
library;

class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'حدث خطأ في الخادم']);
}

class UnauthorizedException implements Exception {
  const UnauthorizedException();
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'خطأ في التخزين المحلي']);
}

class NetworkException implements Exception {
  const NetworkException();
}

class NotFoundException implements Exception {
  final String message;
  const NotFoundException([this.message = 'العنصر غير موجود']);
}
