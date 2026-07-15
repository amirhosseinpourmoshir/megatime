import 'package:flutter/material.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/config/routes.dart';
import '../../../../core/network/api_exception.dart';
import '../../data/models/login_request.dart';
import '../../data/repositories/auth_repository.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final AnimationController _slideController;
  late final AnimationController _scaleController;
  
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _scaleAnimation;
  
  final TextEditingController _employeeCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  
  final AuthRepository _authRepository = AuthRepository();

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _loadSavedCredentials();
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _fadeController.forward();
        _slideController.forward();
        _scaleController.forward();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _employeeCodeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ============ بارگذاری اطلاعات ذخیره‌شده ============
  Future<void> _loadSavedCredentials() async {
    try {
      // ✅ استفاده از متد عمومی AuthRepository
      final employeeCode = await _authRepository.getSavedEmployeeCode();
      if (employeeCode != null && employeeCode.isNotEmpty) {
        _employeeCodeController.text = employeeCode;
        print('✅ Loaded saved employee code: $employeeCode');
      }
    } catch (e) {
      print('❌ Error loading saved credentials: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingXL,
              vertical: AppDimensions.spacingXL,
            ),
            child: Column(
              children: [
                const SizedBox(height: AppDimensions.spacingXL),
                _buildHeader(isDark: isDark),
                const SizedBox(height: AppDimensions.spacingXXL * 1.5),
                _buildLoginForm(isDark: isDark),
                const SizedBox(height: AppDimensions.spacingXXL),
                _buildLoginButton(),
                const SizedBox(height: AppDimensions.spacingLG),
                _buildVersionText(isDark: isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader({required bool isDark}) {
    return Column(
      children: [
        FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: _buildLogo(),
          ),
        ),
        const SizedBox(height: AppDimensions.spacingLG),
        FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: _buildWelcomeText(isDark: isDark),
          ),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryLight, Color(0xFF60A5FA)],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXXL * 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.business_center,
          color: AppColors.textLight,
          size: AppDimensions.iconXL * 2.5,
        ),
      ),
    );
  }

  Widget _buildWelcomeText({required bool isDark}) {
    return Column(
      children: [
        Text(
          'خوش آمدید',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textLight : AppColors.textDark,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSM),
        Text(
          'برای ورود به پنل کاربری اطلاعات خود را وارد کنید',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppDimensions.fontSizeMD,
            color: isDark ? AppColors.textGrayLight : AppColors.textGray,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm({required bool isDark}) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          children: [
            _buildEmployeeCodeField(isDark: isDark),
            const SizedBox(height: AppDimensions.spacingLG),
            _buildPasswordField(isDark: isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeCodeField({required bool isDark}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark 
            ? AppColors.backgroundDarkCard.withValues(alpha: 0.5)
            : AppColors.backgroundLightSurface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: TextFormField(
        controller: _employeeCodeController,
        style: TextStyle(
          color: isDark ? AppColors.textLight : AppColors.textDark,
          fontSize: AppDimensions.fontSizeMD,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.badge, color: AppColors.primary, size: 24),
          hintText: 'کد پرسنلی',
          hintStyle: TextStyle(
            color: isDark 
                ? AppColors.textGrayLight.withValues(alpha: 0.5)
                : AppColors.textGray.withValues(alpha: 0.5),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingMD,
            vertical: AppDimensions.spacingMD,
          ),
        ),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
      ),
    );
  }

  Widget _buildPasswordField({required bool isDark}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark 
            ? AppColors.backgroundDarkCard.withValues(alpha: 0.5)
            : AppColors.backgroundLightSurface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: TextFormField(
        controller: _passwordController,
        style: TextStyle(
          color: isDark ? AppColors.textLight : AppColors.textDark,
          fontSize: AppDimensions.fontSizeMD,
        ),
        obscureText: _obscurePassword,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock_outline, color: AppColors.primary, size: 24),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: isDark ? AppColors.textGrayLight : AppColors.textGray,
              size: 22,
            ),
            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
          hintText: 'رمز عبور',
          hintStyle: TextStyle(
            color: isDark 
                ? AppColors.textGrayLight.withValues(alpha: 0.5)
                : AppColors.textGray.withValues(alpha: 0.5),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingMD,
            vertical: AppDimensions.spacingMD,
          ),
        ),
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (_) => _handleLogin(),
      ),
    );
  }

  Widget _buildLoginButton() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _handleLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textLight,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
            ),
            elevation: 0,
            disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.3),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: AppColors.textLight,
                    strokeWidth: 2.5,
                  ),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('ورود به پنل کاربری'),
                    SizedBox(width: AppDimensions.spacingSM),
                    Icon(Icons.arrow_forward_rounded, size: 22),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildVersionText({required bool isDark}) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Text(
        'نسخه ${AppConfig.appVersion}',
        style: TextStyle(
          fontSize: AppDimensions.fontSizeXS,
          color: isDark 
              ? AppColors.textGray.withValues(alpha: 0.3)
              : AppColors.textGrayLight.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  // ============ منطق ورود ============
  Future<void> _handleLogin() async {
    final employeeCode = _employeeCodeController.text.trim();
    final password = _passwordController.text.trim();

    if (employeeCode.isEmpty || password.isEmpty) {
      _showErrorSnackBar('لطفاً تمام فیلدها را پر کنید');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final request = LoginRequest(
        employeeCode: employeeCode,
        password: password,
      );
      
      final response = await _authRepository.login(request);
      
      if (response.access != null && response.access!.isNotEmpty) {
        _showSuccessSnackBar('ورود موفقیت‌آمیز');
        Navigator.pushReplacementNamed(context, Routes.home);
      } else {
        _showErrorSnackBar('خطا در دریافت توکن');
      }
    } on UnauthorizedException catch (e) {
      _showErrorSnackBar('کد پرسنلی یا رمز عبور اشتباه است');
    } on TimeoutException catch (e) {
      _showErrorSnackBar('زمان درخواست به پایان رسید');
    } on NetworkException catch (e) {
      _showErrorSnackBar('خطا در ارتباط با سرور');
    } on ApiException catch (e) {
      _showErrorSnackBar(e.message);
    } catch (e) {
      _showErrorSnackBar('خطای ناشناخته');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.textLight, size: 24),
            const SizedBox(width: AppDimensions.spacingSM),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: AppColors.textLight, size: 24),
            const SizedBox(width: AppDimensions.spacingSM),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}