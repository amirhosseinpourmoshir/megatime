import 'package:dio/dio.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // تبدیل خطاهای Dio به ApiException
    final apiError = _convertDioError(err);
    handler.reject(apiError);
  }
  
  DioException _convertDioError(DioException err) {
    return DioException(
      requestOptions: err.requestOptions,
      error: err.error,
      response: err.response,
      type: err.type,
    );
  }
}