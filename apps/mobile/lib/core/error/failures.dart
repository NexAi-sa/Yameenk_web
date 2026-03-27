library;

import 'package:equatable/equatable.dart';

/// Base class for all domain-layer failures.
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'حدث خطأ في الخادم']);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'غير مصرح — يرجى تسجيل الدخول']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'تعذّر الاتصال — تحقق من الإنترنت']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'خطأ في التخزين المحلي']);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'العنصر غير موجود']);
}
