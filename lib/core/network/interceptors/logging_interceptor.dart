import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🚀 [${options.method}] ${options.path}');
    print('📦 Headers: ${options.headers}');
    if (options.queryParameters.isNotEmpty) {
      print('📨 Query: ${options.queryParameters}');
    }
    if (options.data != null) {
      print('📦 Body: ${options.data}');
    }
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    super.onRequest(options, handler);
  }
  
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('✅ [${response.statusCode}] ${response.requestOptions.path}');
    print('📦 Response: ${response.data}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    super.onResponse(response, handler);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('❌ [${err.response?.statusCode}] ${err.requestOptions.path}');
    print('📦 Error: ${err.message}');
    if (err.response?.data != null) {
      print('📦 Data: ${err.response?.data}');
    }
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    super.onError(err, handler);
  }
}