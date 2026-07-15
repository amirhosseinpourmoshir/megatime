import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    
    if (connectivityResult == ConnectivityResult.none) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: 'اتصال اینترنت برقرار نیست',
          type: DioExceptionType.connectionError,
        ),
      );
      return;
    }
    
    super.onRequest(options, handler);
  }
}