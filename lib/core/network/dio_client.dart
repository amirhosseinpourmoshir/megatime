import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../config/app_config.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/connectivity_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/retry_interceptor.dart';
import 'api_exception.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio _dio;
  
  factory ApiClient() => _instance;
  
  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.fullBaseUrl,
        connectTimeout: AppConfig.connectTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        sendTimeout: AppConfig.sendTimeout,
        contentType: 'application/json',
        responseType: ResponseType.json,
        headers: {
          'Accept': 'application/json',
          'Accept-Language': 'fa',
        },
      ),
    );
    
    _setupInterceptors();
  }
  
  Dio get dio => _dio;
  
  void _setupInterceptors() {
    _dio.interceptors.addAll([
      ConnectivityInterceptor(),
      AuthInterceptor(),
      LoggingInterceptor(),
      ErrorInterceptor(),
      RetryInterceptor(),
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    ]);
  }
  
  // ============ متدهای عمومی ============
  
  Future<T> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return _handleResponse(response, fromJson);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException(message: 'خطای ناشناخته');
    }
  }
  
  Future<T> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('📍 POST Request: ${_dio.options.baseUrl}$endpoint');
      print('📦 Data: $data');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      
      print('✅ Status: ${response.statusCode}');
      print('✅ Data: ${response.data}');
      
      return _handleResponse(response, fromJson);
    } on DioException catch (e) {
      print('❌ Dio Error: ${e.message}');
      print('❌ Type: ${e.type}');
      print('❌ Response: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ Error: $e');
      throw ApiException(message: 'خطای ناشناخته');
    }
  }
  
  Future<T> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return _handleResponse(response, fromJson);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException(message: 'خطای ناشناخته');
    }
  }
  
  Future<T> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return _handleResponse(response, fromJson);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException(message: 'خطای ناشناخته');
    }
  }
  
  Future<T> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse(response, fromJson);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException(message: 'خطای ناشناخته');
    }
  }
  
  // ============ آپلود فایل ============
  
  Future<T> uploadFile<T>(
    String endpoint,
    String filePath, {
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final formData = FormData();
      
      formData.files.add(
        MapEntry(
          'file',
          await MultipartFile.fromFile(filePath),
        ),
      );
      
      if (data != null) {
        data.forEach((key, value) {
          formData.fields.add(MapEntry(key, value.toString()));
        });
      }
      
      final response = await _dio.post(
        endpoint,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
        onSendProgress: onSendProgress,
      );
      
      return _handleResponse(response, fromJson);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException(message: 'خطا در آپلود فایل');
    }
  }
  
  // ============ پردازش پاسخ ============
  
  T _handleResponse<T>(
    Response response,
    T Function(dynamic) fromJson,
  ) {
    final statusCode = response.statusCode;
    final data = response.data;
    
    print('📡 _handleResponse - Status: $statusCode');
    print('📡 _handleResponse - Data Type: ${data.runtimeType}');
    
    if (statusCode == null) {
      throw ApiException(message: 'پاسخی دریافت نشد');
    }
    
    if (statusCode >= 200 && statusCode < 300) {
      try {
        return fromJson(data);
      } catch (e) {
        print('❌ fromJson Error: $e');
        throw ApiException(
          message: 'خطا در پردازش داده‌ها: ${e.toString()}',
          data: data,
        );
      }
    }
    
    throw _handleErrorResponse(statusCode, data);
  }
  
  Exception _handleErrorResponse(int statusCode, dynamic data) {
    final message = data?['message'] ?? 
                    data?['msg'] ?? 
                    data?['error'] ?? 
                    'خطای ناشناخته';
    
    switch (statusCode) {
      case 400:
        return ValidationException(message: message, errors: data?['errors']);
      case 401:
        return UnauthorizedException(message: message);
      case 403:
        return ForbiddenException(message: message);
      case 404:
        return NotFoundException(message: message);
      case 422:
        return ValidationException(message: message, errors: data?['errors']);
      case 429:
        return RateLimitException(message: 'درخواست بیش از حد مجاز');
      case 500:
        return ServerException(message: message);
      default:
        return ApiException(message: message, statusCode: statusCode, data: data);
    }
  }
  
  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException();
      case DioExceptionType.connectionError:
        return NetworkException();
      case DioExceptionType.badResponse:
        return _handleErrorResponse(
          error.response?.statusCode ?? 500,
          error.response?.data,
        );
      case DioExceptionType.cancel:
        return CancelException();
      default:
        return ApiException(
          message: error.message ?? 'خطای ناشناخته',
          statusCode: error.response?.statusCode,
        );
    }
  }
}