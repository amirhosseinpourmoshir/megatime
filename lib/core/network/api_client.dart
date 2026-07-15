import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../config/app_config.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/connectivity_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/retry_interceptor.dart';
import 'api_exception.dart';
import 'api_response.dart';

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
        contentType: AppConfig.contentType,
        responseType: ResponseType.json,
        headers: {
          'Accept': AppConfig.accept,
          'Accept-Language': 'fa',
          'App-Version': AppConfig.appVersion,
          'Platform': AppConfig.deviceTypeMobile,
          'Content-Type': AppConfig.contentType,
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
      RetryInterceptor(
        maxRetries: 3,
        retryDelay: const Duration(seconds: 2),
      ),
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
  
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    T Function(dynamic)? fromJson,
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
  
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
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
  
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    T Function(dynamic)? fromJson,
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
  
  Future<ApiResponse<T>> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    T Function(dynamic)? fromJson,
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
  
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
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
  
  Future<ApiResponse<T>> uploadFile<T>(
    String endpoint,
    String filePath, {
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
    T Function(dynamic)? fromJson,
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
  
  Future<ApiResponse<T>> uploadMultipleFiles<T>(
    String endpoint,
    List<String> filePaths, {
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final formData = FormData();
      
      for (int i = 0; i < filePaths.length; i++) {
        formData.files.add(
          MapEntry(
            'files[$i]',
            await MultipartFile.fromFile(filePaths[i]),
          ),
        );
      }
      
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
      throw ApiException(message: 'خطا در آپلود فایل‌ها');
    }
  }
  
  // ============ دانلود فایل ============
  
  Future<String> downloadFile(
    String endpoint,
    String savePath, {
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      await _dio.download(
        endpoint,
        savePath,
        queryParameters: queryParameters,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );
      return savePath;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException(message: 'خطا در دانلود فایل');
    }
  }
  
  // ============ پردازش پاسخ ============
  
  ApiResponse<T> _handleResponse<T>(
    Response response,
    T Function(dynamic)? fromJson,
  ) {
    final statusCode = response.statusCode;
    final data = response.data;
    
    if (statusCode == null) {
      throw ApiException(message: 'پاسخی دریافت نشد');
    }
    
    if (statusCode >= 200 && statusCode < 300) {
      try {
        // اگر ApiResponse باشد
        if (data is Map<String, dynamic>) {
          if (data.containsKey('data') || data.containsKey('success')) {
            return ApiResponse<T>.fromJson(
              data,
              fromJson != null ? fromJson : (d) => d as T,
            );
          }
        }
        
        // اگر مستقیم داده باشد
        final parsedData = fromJson != null ? fromJson(data) : data as T;
        return ApiResponse<T>(
          success: true,
          message: 'عملیات موفقیت‌آمیز',
          data: parsedData,
          statusCode: statusCode,
        );
      } catch (e) {
        throw ApiException(
          message: 'خطا در پردازش داده‌ها',
          data: data,
        );
      }
    }
    
    throw _handleErrorResponse(statusCode, data);
  }
  
  // ============ پردازش خطا ============
  
  Exception _handleErrorResponse(int statusCode, dynamic data) {
    final message = data?['message'] ?? 
                    data?['msg'] ?? 
                    data?['error'] ?? 
                    'خطای ناشناخته';
    
    final errors = data?['errors'];
    
    switch (statusCode) {
      case 400:
        return ValidationException(
          message: message,
          errors: errors,
        );
      case 401:
        return UnauthorizedException(message: message);
      case 403:
        return ForbiddenException(message: message);
      case 404:
        return NotFoundException(message: message);
      case 422:
        return ValidationException(
          message: message,
          errors: errors,
        );
      case 429:
        return RateLimitException(message: 'درخواست بیش از حد مجاز');
      case 500:
        return ServerException(message: message);
      case 502:
      case 503:
      case 504:
        return ServerException(message: 'سرور در دسترس نیست');
      default:
        return ApiException(
          message: message,
          statusCode: statusCode,
          data: data,
        );
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
      case DioExceptionType.badCertificate:
        return ApiException(message: 'مشکل در گواهی امنیتی');
      default:
        return ApiException(
          message: error.message ?? 'خطای ناشناخته',
          statusCode: error.response?.statusCode,
        );
    }
  }
}

// ============ سینگلتون برای دسترسی راحت ============
final apiClient = ApiClient().dio;