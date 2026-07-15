import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration retryDelay;
  
  RetryInterceptor({
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 2),
  });
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // فقط خطاهای شبکه و تایم‌اوت رو دوباره تلاش کن
    if (_shouldRetry(err)) {
      var retryCount = err.requestOptions.extra['retry_count'] ?? 0;
      
      if (retryCount < maxRetries) {
        retryCount++;
        err.requestOptions.extra['retry_count'] = retryCount;
        
        // تاخیر قبل از تلاش مجدد
        await Future.delayed(retryDelay * retryCount);
        
        try {
          final response = await Dio().request(
            err.requestOptions.path,
            options: Options(
              method: err.requestOptions.method,
              headers: err.requestOptions.headers,
              responseType: err.requestOptions.responseType,
              contentType: err.requestOptions.contentType,
              sendTimeout: err.requestOptions.sendTimeout,
              receiveTimeout: err.requestOptions.receiveTimeout,
              extra: err.requestOptions.extra,
              responseDecoder: err.requestOptions.responseDecoder,
              listFormat: err.requestOptions.listFormat,
              validateStatus: err.requestOptions.validateStatus,
              receiveDataWhenStatusError: err.requestOptions.receiveDataWhenStatusError,
              followRedirects: err.requestOptions.followRedirects,
              maxRedirects: err.requestOptions.maxRedirects,
              persistentConnection: err.requestOptions.persistentConnection,
            ),
            data: err.requestOptions.data,
            queryParameters: err.requestOptions.queryParameters,
          );
          
          handler.resolve(response);
          return;
        } catch (e) {
          // ادامه به خطا
        }
      }
    }
    
    super.onError(err, handler);
  }
  
  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
           err.type == DioExceptionType.sendTimeout ||
           err.type == DioExceptionType.receiveTimeout ||
           err.type == DioExceptionType.connectionError ||
           err.type == DioExceptionType.unknown;
  }
}