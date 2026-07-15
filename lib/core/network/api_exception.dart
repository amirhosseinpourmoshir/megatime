class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;
  
  ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });
  
  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

class NetworkException extends ApiException {
  NetworkException({String message = 'خطا در ارتباط با سرور'})
      : super(message: message);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException({String message = 'نشست شما منقضی شده است'})
      : super(message: message, statusCode: 401);
}

class ForbiddenException extends ApiException {
  ForbiddenException({String message = 'دسترسی غیرمجاز'})
      : super(message: message, statusCode: 403);
}

class NotFoundException extends ApiException {
  NotFoundException({String message = 'اطلاعات درخواستی یافت نشد'})
      : super(message: message, statusCode: 404);
}

class ServerException extends ApiException {
  ServerException({String message = 'خطای سرور'})
      : super(message: message, statusCode: 500);
}

class ValidationException extends ApiException {
  final Map<String, List<String>>? errors;
  
  ValidationException({
    String message = 'خطای اعتبارسنجی',
    this.errors,
  }) : super(message: message, statusCode: 422);
}

class TimeoutException extends ApiException {
  TimeoutException({String message = 'زمان درخواست به پایان رسید'})
      : super(message: message);
}

class CancelException extends ApiException {
  CancelException({String message = 'درخواست لغو شد'})
      : super(message: message);
}

class RateLimitException extends ApiException {
  RateLimitException({String message = 'درخواست بیش از حد مجاز'})
      : super(message: message, statusCode: 429);
}