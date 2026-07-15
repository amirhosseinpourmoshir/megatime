import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import '../network/api_client.dart';
import '../network/api_exception.dart';
import 'token_manager.dart';
import '../../features/auth/data/models/user_model.dart';

class AuthService {
  final ApiClient _client = ApiClient();
  final TokenManager _tokenManager = TokenManager();
  
  // ============ ورود ============
  Future<Map<String, dynamic>> login({
    required String employeeCode,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      print('🔐 AuthService.login called');
      print('📡 URL: ${AppConfig.fullBaseUrl}${AppConfig.login}');
      print('📦 Data: employeeCode=$employeeCode, password=***');
      
      final response = await _client.post<Map<String, dynamic>>(
        AppConfig.login,
        data: {
          'employee_code': employeeCode,
          'password': password,
        },
        fromJson: (data) => data as Map<String, dynamic>,
      );
      
      print('✅ Login response received: ${response.data}');
      
      final data = response.data ?? {};
      
      final accessToken = data['access'] as String?;
      final refreshToken = data['refresh'] as String?;
      
      if (accessToken == null || accessToken.isEmpty) {
        return {
          'success': false,
          'message': 'توکن دسترسی دریافت نشد',
        };
      }
      
      if (refreshToken == null || refreshToken.isEmpty) {
        return {
          'success': false,
          'message': 'رفرش توکن دریافت نشد',
        };
      }
      
      // ذخیره توکن‌ها
      await _tokenManager.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConfig.employeeCodeKey, employeeCode);
      await prefs.setBool(AppConfig.rememberMeKey, rememberMe);
      
      if (data['user'] != null) {
        final userData = data['user'];
        await prefs.setString(AppConfig.userDataKey, jsonEncode(userData));
      }
      
      return {
        'success': true,
        'message': 'ورود موفقیت‌آمیز',
        'data': data,
      };
    } on ApiException catch (e) {
      print('❌ ApiException: ${e.message}');
      return {
        'success': false,
        'message': e.message,
        'errors': e.data?['errors'],
        'statusCode': e.statusCode,
      };
    } catch (e) {
      print('❌ Error: $e');
      return {
        'success': false,
        'message': 'خطا در ارتباط با سرور',
        'error': e.toString(),
      };
    }
  }
  
  // ============ خروج ============
  Future<void> logout() async {
    try {
      await _client.post<void>(
        AppConfig.logout,
        fromJson: (_) => null,
      );
    } catch (e) {
      // حتی اگر خطا داشت، توکن‌ها رو پاک کن
    } finally {
      await _tokenManager.clearTokens();
    }
  }
  
  // ============ دریافت اطلاعات کاربر ============
  Future<Map<String, dynamic>> getProfile() async {
    try {
      await _tokenManager.refreshTokenManually();
      
      final response = await _client.get<Map<String, dynamic>>(
        AppConfig.profile,
        fromJson: (data) => data as Map<String, dynamic>,
      );
      
      final userData = response.data ?? {};
      final user = UserModel.fromJson(userData);
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConfig.userDataKey, jsonEncode(user.toJson()));
      
      return {
        'success': true,
        'data': user,
      };
    } on UnauthorizedException catch (e) {
      await _tokenManager.clearTokens();
      return {
        'success': false,
        'message': 'نشست شما منقضی شده است',
      };
    } on ApiException catch (e) {
      return {
        'success': false,
        'message': e.message,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'خطا در دریافت اطلاعات کاربر',
      };
    }
  }
  
  // ============ به‌روزرسانی پروفایل ============
  Future<Map<String, dynamic>> updateProfile({
    required String firstName,
    required String lastName,
    String? email,
    String? phone,
    String? address,
    String? position,
    String? jobRole,
  }) async {
    try {
      final response = await _client.put<Map<String, dynamic>>(
        AppConfig.updateProfile,
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'phone': phone,
          'address': address,
          'position': position,
          'job_role': jobRole,
        },
        fromJson: (data) => data as Map<String, dynamic>,
      );
      
      final userData = response.data ?? {};
      final user = UserModel.fromJson(userData);
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConfig.userDataKey, jsonEncode(user.toJson()));
      
      return {
        'success': true,
        'message': 'پروفایل با موفقیت به‌روزرسانی شد',
        'data': user,
      };
    } on ApiException catch (e) {
      return {
        'success': false,
        'message': e.message,
        'errors': e.data?['errors'],
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'خطا در به‌روزرسانی پروفایل',
      };
    }
  }
  
  // ============ آپلود آواتار ============
  Future<Map<String, dynamic>> uploadAvatar(String filePath) async {
    try {
      final response = await _client.uploadFile<Map<String, dynamic>>(
        AppConfig.uploadAvatar,
        filePath,
        fromJson: (data) => data as Map<String, dynamic>,
      );
      
      final avatarUrl = response.data?['avatar_url'] as String? ?? '';
      
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(AppConfig.userDataKey);
      if (userJson != null) {
        try {
          final userData = jsonDecode(userJson);
          userData['profile_image'] = avatarUrl;
          await prefs.setString(AppConfig.userDataKey, jsonEncode(userData));
        } catch (e) {
          // خطا در به‌روزرسانی
        }
      }
      
      return {
        'success': true,
        'message': 'آواتار با موفقیت آپلود شد',
        'data': avatarUrl,
      };
    } on ApiException catch (e) {
      return {
        'success': false,
        'message': e.message,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'خطا در آپلود آواتار',
      };
    }
  }
  
  // ============ تغییر رمز عبور ============
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      if (newPassword != confirmPassword) {
        return {
          'success': false,
          'message': 'رمز عبور جدید و تکرار آن مطابقت ندارند',
        };
      }
      
      await _client.post<Map<String, dynamic>>(
        AppConfig.changePassword,
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
          'confirm_password': confirmPassword,
        },
        fromJson: (data) => data as Map<String, dynamic>,
      );
      
      return {
        'success': true,
        'message': 'رمز عبور با موفقیت تغییر کرد',
      };
    } on ApiException catch (e) {
      return {
        'success': false,
        'message': e.message,
        'errors': e.data?['errors'],
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'خطا در تغییر رمز عبور',
      };
    }
  }
  
  // ============ فراموشی رمز عبور ============
  Future<Map<String, dynamic>> forgotPassword({
    required String employeeCode,
  }) async {
    try {
      await _client.post<Map<String, dynamic>>(
        AppConfig.forgotPassword,
        data: {
          'employee_code': employeeCode,
        },
        fromJson: (data) => data as Map<String, dynamic>,
      );
      
      return {
        'success': true,
        'message': 'لینک بازیابی رمز عبور ارسال شد',
      };
    } on ApiException catch (e) {
      return {
        'success': false,
        'message': e.message,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'خطا در ارسال درخواست',
      };
    }
  }
  
  // ============ بازنشانی رمز عبور ============
  Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      if (newPassword != confirmPassword) {
        return {
          'success': false,
          'message': 'رمز عبور جدید و تکرار آن مطابقت ندارند',
        };
      }
      
      await _client.post<Map<String, dynamic>>(
        AppConfig.resetPassword,
        data: {
          'token': token,
          'new_password': newPassword,
          'confirm_password': confirmPassword,
        },
        fromJson: (data) => data as Map<String, dynamic>,
      );
      
      return {
        'success': true,
        'message': 'رمز عبور با موفقیت بازنشانی شد',
      };
    } on ApiException catch (e) {
      return {
        'success': false,
        'message': e.message,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'خطا در بازنشانی رمز عبور',
      };
    }
  }
  
  // ============ رفرش توکن ============
  Future<String?> refreshToken() async {
    final success = await _tokenManager.refreshTokenManually();
    if (success) {
      return await _tokenManager.getAccessToken();
    }
    return null;
  }
  
  // ============ بررسی وضعیت احراز هویت ============
  Future<bool> isAuthenticated() async {
    return await _tokenManager.isTokenValid();
  }
  
  // ============ دریافت توکن ============
  Future<String?> getAccessToken() async {
    return await _tokenManager.getAccessToken();
  }
  
  // ============ دریافت اطلاعات کاربر ذخیره‌شده ============
  Future<UserModel?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(AppConfig.userDataKey);
    
    if (userJson != null && userJson.isNotEmpty) {
      try {
        final data = jsonDecode(userJson);
        return UserModel.fromJson(data);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
  
  // ============ دریافت کد پرسنلی ذخیره‌شده ============
  Future<String?> getSavedEmployeeCode() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool(AppConfig.rememberMeKey) ?? false;
    if (rememberMe) {
      return prefs.getString(AppConfig.employeeCodeKey);
    }
    return null;
  }
  
  // ============ شروع رفرش خودکار ============
  void startAutoRefresh() {
    _tokenManager.startAutoRefresh();
  }
  
  // ============ توقف رفرش خودکار ============
  void stopAutoRefresh() {
    _tokenManager.stopAutoRefresh();
  }
}