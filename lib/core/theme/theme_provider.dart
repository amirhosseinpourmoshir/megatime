import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDark = true;

  bool get isDark => _isDark;
  ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;

  ThemeProvider() {
    _loadTheme();
  }

  // ============ بارگذاری تم از SharedPreferences ============
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool(AppConfig.isDarkModeKey) ?? true;
    notifyListeners();
  }

  // ============ تغییر تم ============
  Future<void> toggleTheme() async {
    _isDark = !_isDark;
    
    // ذخیره در SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConfig.isDarkModeKey, _isDark);
    
    notifyListeners(); // ✅ اطلاع به همه ویجت‌ها برای بازسازی
  }

  // ============ تنظیم تم به صورت دستی ============
  Future<void> setTheme(bool isDark) async {
    _isDark = isDark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConfig.isDarkModeKey, _isDark);
    notifyListeners();
  }
}