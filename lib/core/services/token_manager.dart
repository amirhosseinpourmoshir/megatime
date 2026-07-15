import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import '../network/api_client.dart';
import '../network/api_exception.dart';

class TokenManager {
  static final TokenManager _instance = TokenManager._internal();
  Timer? _refreshTimer;
  bool _isRefreshing = false;
  
  factory TokenManager() => _instance;
  
  TokenManager._internal();
  
  void startAutoRefresh() {
    _stopAutoRefresh();
    _refreshTimer = Timer.periodic(AppConfig.refreshInterval, (timer) async {
      await _refreshTokenIfNeeded();
    });
    print('🔄 Token auto-refresh started');
  }
  
  void _stopAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }
  
  void stopAutoRefresh() {
    _stopAutoRefresh();
  }
  
  Future<bool> _refreshTokenIfNeeded() async {
    if (_isRefreshing) return false;
    
    _isRefreshing = true;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString(AppConfig.refreshTokenKey);
      
      if (refreshToken == null || refreshToken.isEmpty) {
        _isRefreshing = false;
        return false;
      }
      
      final apiClient = ApiClient();
      final response = await apiClient.post<Map<String, dynamic>>(
        AppConfig.refreshToken,
        data: {'refresh': refreshToken},
        fromJson: (data) => data as Map<String, dynamic>,
      );
      
      final newAccessToken = response.data?['access'] as String?;
      
      if (newAccessToken != null && newAccessToken.isNotEmpty) {
        await prefs.setString(AppConfig.accessTokenKey, newAccessToken);
        _isRefreshing = false;
        return true;
      }
      
      _isRefreshing = false;
      return false;
    } catch (e) {
      _isRefreshing = false;
      return false;
    }
  }
  
  Future<bool> refreshTokenManually() async {
    return await _refreshTokenIfNeeded();
  }
  
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setString(AppConfig.accessTokenKey, accessToken);
    await prefs.setString(AppConfig.refreshTokenKey, refreshToken);
    await prefs.setBool(AppConfig.isLoggedInKey, true);
    
    startAutoRefresh();
    print('✅ Tokens saved');
  }
  
  Future<void> clearTokens() async {
    _stopAutoRefresh();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConfig.accessTokenKey);
    await prefs.remove(AppConfig.refreshTokenKey);
    await prefs.remove(AppConfig.userDataKey);
    await prefs.remove(AppConfig.employeeCodeKey);
    await prefs.remove(AppConfig.isLoggedInKey);
    
    print('✅ Tokens cleared');
  }
  
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConfig.accessTokenKey);
  }
  
  Future<bool> isTokenValid() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}