import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/network/api_exception.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/user_model.dart';

class AuthRepository {
  final AuthService _authService = AuthService();
  
  // ============ ورود ============
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      print('🔐 AuthRepository.login called');
      print('📦 EmployeeCode: ${request.employeeCode}');
      
      final result = await _authService.login(
        employeeCode: request.employeeCode,
        password: request.password,
      );
      
      print('📦 Login result: $result');
      
      // ❌ اگر خطا بود
      if (!result['success']) {
        final message = result['message'] ?? 'خطا در ورود';
        final statusCode = result['statusCode'];
        final errors = result['errors'];
        
        // تشخیص نوع خطا بر اساس statusCode یا پیام
        if (statusCode == 401 || 
            message.contains('اشتباه') || 
            message.contains('نامعتبر') ||
            message.contains('رمز عبور')) {
          throw UnauthorizedException(message: message);
        }
        
        if (statusCode == 422 || errors != null) {
          throw ValidationException(message: message, errors: errors);
        }
        
        if (statusCode == 404) {
          throw NotFoundException(message: message);
        }
        
        if (statusCode == 500) {
          throw ServerException(message: message);
        }
        
        throw ApiException(message: message);
      }
      
      // ✅ اگر موفق بود
      final data = result['data'] ?? {};
      
      final accessToken = data['access'] as String?;
      final refreshToken = data['refresh'] as String?;
      
      if (accessToken == null || accessToken.isEmpty) {
        throw ApiException(message: 'توکن دسترسی دریافت نشد');
      }
      
      if (refreshToken == null || refreshToken.isEmpty) {
        throw ApiException(message: 'رفرش توکن دریافت نشد');
      }
      
      return LoginResponse(
        access: accessToken,
        refresh: refreshToken,
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      print('❌ Login error: $e');
      throw ApiException(message: 'خطا در ارتباط با سرور');
    }
  }
  
  // ============ خروج ============
  Future<void> logout() async {
    await _authService.logout();
  }
  
  // ============ دریافت اطلاعات کاربر از API ============
  Future<UserModel?> getProfile() async {
    try {
      final result = await _authService.getProfile();
      
      if (result['success'] && result['data'] != null) {
        return result['data'] as UserModel?;
      }
      return null;
    } catch (e) {
      print('❌ GetProfile error: $e');
      return null;
    }
  }
  
  // ============ دریافت اطلاعات کاربر ذخیره‌شده ============
  Future<UserModel?> getSavedUser() async {
    try {
      return await _authService.getSavedUser();
    } catch (e) {
      print('❌ GetSavedUser error: $e');
      return null;
    }
  }
  
  // ============ دریافت کد پرسنلی ذخیره‌شده ============
  Future<String?> getSavedEmployeeCode() async {
    try {
      return await _authService.getSavedEmployeeCode();
    } catch (e) {
      print('❌ GetSavedEmployeeCode error: $e');
      return null;
    }
  }
  
  // ============ بررسی وضعیت احراز هویت ============
  Future<bool> isAuthenticated() async {
    return await _authService.isAuthenticated();
  }
  
  // ============ دریافت توکن ============
  Future<String?> getAccessToken() async {
    return await _authService.getAccessToken();
  }
}