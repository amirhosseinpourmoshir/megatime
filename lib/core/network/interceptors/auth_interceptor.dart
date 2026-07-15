import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/app_config.dart';
import '../../services/token_manager.dart';

class AuthInterceptor extends Interceptor {
  final TokenManager _tokenManager = TokenManager();
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConfig.accessTokenKey);  // ✅ استفاده از accessTokenKey
      
      if (token != null && token.isNotEmpty) {
        options.headers[AppConfig.authorization] = '${AppConfig.bearer} $token';
      }
    } catch (e) {
      // خطا در دریافت توکن
    }
    
    super.onRequest(options, handler);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString(AppConfig.refreshTokenKey);
      
      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          final success = await _tokenManager.refreshTokenManually();
          
          if (success) {
            final newToken = await _tokenManager.getAccessToken();
            
            if (newToken != null && newToken.isNotEmpty) {
              final newRequest = await _retryRequest(err.requestOptions, newToken);
              handler.resolve(newRequest);
              return;
            }
          }
        } catch (e) {
          await _tokenManager.clearTokens();
        }
      } else {
        await _tokenManager.clearTokens();
      }
    }
    
    super.onError(err, handler);
  }
  
  Future<Response> _retryRequest(RequestOptions options, String newToken) async {
    options.headers[AppConfig.authorization] = '${AppConfig.bearer} $newToken';
    return await Dio().request(
      options.path,
      options: Options(
        method: options.method,
        headers: options.headers,
        responseType: options.responseType,
        contentType: options.contentType,
        sendTimeout: options.sendTimeout,
        receiveTimeout: options.receiveTimeout,
        extra: options.extra,
        responseDecoder: options.responseDecoder,
        listFormat: options.listFormat,
        validateStatus: options.validateStatus,
        receiveDataWhenStatusError: options.receiveDataWhenStatusError,
        followRedirects: options.followRedirects,
        maxRedirects: options.maxRedirects,
        persistentConnection: options.persistentConnection,
      ),
      data: options.data,
      queryParameters: options.queryParameters,
    );
  }
}