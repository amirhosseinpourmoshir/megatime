class AppConfig {
  // ============ Base URLs ============
  static const String baseUrl = 'http://127.0.0.1:8000';
  static const String apiPrefix = '/api/v1';
  static String get fullBaseUrl => '$baseUrl$apiPrefix';
  
  // ============ API Endpoints ============
  // Auth
  static const String login = '/auth/login/';  // ✅ اسلش آخر
  static const String logout = '/auth/logout/';  // ✅ اسلش آخر
  static const String refreshToken = '/auth/refresh/';  // ✅ اسلش آخر
  static const String verify = '/auth/verify/';  // ✅ اسلش آخر
  static const String register = '/auth/register/';
  static const String forgotPassword = '/auth/forgot-password/';
  static const String resetPassword = '/auth/reset-password/';
  static const String changePassword = '/auth/change-password/';
  
  // User
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/profile/update';
  static const String uploadAvatar = '/user/profile/avatar';
  static const String users = '/users';
  static const String userDetail = '/users/{id}';
  
  // Employees
  static const String employees = '/employees';
  static const String employeeDetail = '/employees/{id}';
  static const String employeeCreate = '/employees/create';
  static const String employeeUpdate = '/employees/{id}/update';
  static const String employeeDelete = '/employees/{id}/delete';
  static const String employeeSearch = '/employees/search';
  static const String employeeDepartments = '/employees/departments';
  static const String employeePositions = '/employees/positions';
  
  // Attendance
  static const String attendance = '/attendance';
  static const String attendanceCheckIn = '/attendance/check-in';
  static const String attendanceCheckOut = '/attendance/check-out';
  static const String attendanceHistory = '/attendance/history';
  static const String attendanceSummary = '/attendance/summary';
  static const String attendanceReport = '/attendance/report';
  static const String attendanceDaily = '/attendance/daily';
  static const String attendanceMonthly = '/attendance/monthly';
  
  // Leave Requests
  static const String leaveRequests = '/leave-requests';
  static const String leaveRequestDetail = '/leave-requests/{id}';
  static const String leaveRequestCreate = '/leave-requests/create';
  static const String leaveRequestApprove = '/leave-requests/{id}/approve';
  static const String leaveRequestReject = '/leave-requests/{id}/reject';
  static const String leaveTypes = '/leave-types';
  static const String leaveBalance = '/leave-balance';
  
  // Dashboard
  static const String dashboard = '/dashboard';
  static const String dashboardStats = '/dashboard/stats';
  static const String dashboardCharts = '/dashboard/charts';
  static const String dashboardRecent = '/dashboard/recent';
  
  // Notifications
  static const String notifications = '/notifications';
  static const String notificationMarkRead = '/notifications/{id}/read';
  static const String notificationMarkAllRead = '/notifications/read-all';
  static const String notificationCount = '/notifications/count';
  
  // Settings
  static const String settings = '/settings';
  static const String settingsUpdate = '/settings/update';
  static const String settingsCompany = '/settings/company';
  static const String settingsHolidays = '/settings/holidays';
  
  // Reports
  static const String reports = '/reports';
  static const String reportsAttendance = '/reports/attendance';
  static const String reportsLeave = '/reports/leave';
  static const String reportsEmployees = '/reports/employees';
  static const String reportsExport = '/reports/export';
  
  // Files
  static const String upload = '/upload';
  static const String download = '/download/{id}';
  static const String files = '/files';
  static const String fileDelete = '/files/{id}/delete';
  
  // ============ Token Lifetimes ============
  static const int accessTokenLifetimeHours = 2;
  static const int refreshTokenLifetimeDays = 7;
  static const int refreshIntervalMinutes = 119;
  static const Duration refreshInterval = Duration(minutes: 119);
  static const int maxRefreshAttempts = 3;
  static const Duration refreshRetryDelay = Duration(seconds: 5);
  
  // ============ Timeouts ============
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  static const Duration uploadTimeout = Duration(minutes: 5);
  static const Duration downloadTimeout = Duration(minutes: 10);
  
  // ============ Shared Preferences Keys ============
  // ✅ همه اینا با هم هماهنگ هستن
  static const String accessTokenKey = 'access_token';      // ← اسم اصلی
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String rememberMeKey = 'remember_me';
  static const String employeeCodeKey = 'employee_code';
  static const String passwordKey = 'password';
  static const String isLoggedInKey = 'is_logged_in';
  static const String lastRefreshTimeKey = 'last_refresh_time';
  static const String tokenExpiryTimeKey = 'token_expiry_time';
  
  // Theme
  static const String themeModeKey = 'theme_mode';
  static const String languageKey = 'language';
  static const String isDarkModeKey = 'is_dark_mode';
  
  // App
  static const String appVersion = '1.0.0';
  static const int buildNumber = 1;
  static const String firstLaunchKey = 'first_launch';
  static const String lastVersionKey = 'last_version';
  
  // ============ Headers ============
  static const String contentType = 'application/json';
  static const String accept = 'application/json';
  static const String acceptLanguage = 'Accept-Language';
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';
  static const String deviceType = 'Device-Type';
  static const String deviceId = 'Device-Id';
  static const String appVersionHeader = 'App-Version';
  static const String platform = 'Platform';
  
  // ============ Device Types ============
  static const String deviceTypeMobile = 'mobile';
  static const String deviceTypeWeb = 'web';
  static const String deviceTypeDesktop = 'desktop';
  static const String platformAndroid = 'android';
  static const String platformIOS = 'ios';
  static const String platformWeb = 'web';
  static const String platformWindows = 'windows';
  static const String platformMacOS = 'macos';
  static const String platformLinux = 'linux';
  
  // ============ Pagination ============
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  static const int minPageSize = 5;
  static const String sortAsc = 'asc';
  static const String sortDesc = 'desc';
  
  // ============ Cache ============
  static const Duration cacheDuration = Duration(minutes: 5);
  static const Duration cacheMaxAge = Duration(hours: 24);
  static const int cacheMaxSize = 100;
  
  // ============ Security ============
  static const int maxLoginAttempts = 5;
  static const Duration lockoutDuration = Duration(minutes: 15);
  static const int minPasswordLength = 8;
  static const bool requireSpecialChar = true;
  static const bool requireNumber = true;
  static const bool requireUpperCase = true;
  static const bool requireLowerCase = true;
  
  // ============ Validation ============
  static const String phoneRegex = r'^09[0-9]{9}$';
  static const String emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String employeeCodeRegex = r'^[0-9]{5,10}$';
  static const String nationalCodeRegex = r'^[0-9]{10}$';
  static const String postalCodeRegex = r'^[0-9]{10}$';
  
  // ============ Storage ============
  static const String storagePath = '/storage';
  static const String imagesPath = '/storage/images';
  static const String filesPath = '/storage/files';
  static const String tempPath = '/storage/temp';
  static const String cachePath = '/storage/cache';
  static const String logsPath = '/storage/logs';
  
  // ============ API Response Keys ============
  static const String responseSuccess = 'success';
  static const String responseMessage = 'message';
  static const String responseData = 'data';
  static const String responseErrors = 'errors';
  static const String responseStatusCode = 'statusCode';
  static const String responseAccess = 'access';
  static const String responseRefresh = 'refresh';
}