import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/config/routes.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/config/app_config.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _mainController;
  late final AnimationController _rotationController;
  late final AnimationController _particleController;
  late final AnimationController _textController;
  
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _rotationAnimation;
  late final Animation<double> _particleAnimation;
  late final Animation<Offset> _slideAnimation;
  
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _checkAuthAndNavigate();
  }
  
  void _initAnimations() {
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Curves.easeOut,
      ),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Curves.easeOutBack,
      ),
    );
    
    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * 3.14159).animate(
      CurvedAnimation(
        parent: _rotationController,
        curve: Curves.linear,
      ),
    );
    
    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _particleController,
        curve: Curves.easeInOut,
      ),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeOutCubic,
      ),
    );
    
    _mainController.forward();
    _rotationController.repeat();
    _particleController.repeat(reverse: true);
    _textController.forward();
  }
  
  // ============ بررسی احراز هویت و هدایت ============
  Future<void> _checkAuthAndNavigate() async {
    // ۴ ثانیه صبر کن تا اسپلش نمایش داده بشه
    await Future.delayed(const Duration(seconds: 4));
    
    if (!mounted) return;
    
    try {
      // بررسی کن که کاربر لاگین هست یا نه
      final isLoggedIn = await _authService.isAuthenticated();
      
      print('🔐 Splash - isLoggedIn: $isLoggedIn');
      
      if (isLoggedIn) {
        // ✅ اگر لاگین بود، برو به صفحه اصلی
        print('✅ User is logged in, navigating to home...');
        // شروع رفرش خودکار توکن
        _authService.startAutoRefresh();
        Navigator.pushReplacementNamed(context, Routes.home);
      } else {
        // ❌ اگر لاگین نبود، برو به صفحه لاگین
        print('❌ User is not logged in, navigating to login...');
        Navigator.pushReplacementNamed(context, Routes.login);
      }
    } catch (e) {
      // در صورت خطا، به صفحه لاگین برو
      print('❌ Error checking auth: $e');
      if (mounted) {
        Navigator.pushReplacementNamed(context, Routes.login);
      }
    }
  }
  
  @override
  void dispose() {
    _mainController.dispose();
    _rotationController.dispose();
    _particleController.dispose();
    _textController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark 
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      body: Stack(
        children: [
          _buildParticleBackground(isDark: isDark),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildConceptualClock(),
                const SizedBox(height: AppDimensions.spacingXXL),
                _buildTextContent(isDark: isDark),
                const SizedBox(height: AppDimensions.spacingXXL * 2),
                _buildLoadingIndicator(isDark: isDark),
              ],
            ),
          ),
          _buildVersion(isDark: isDark),
        ],
      ),
    );
  }
  
  Widget _buildParticleBackground({required bool isDark}) {
    return AnimatedBuilder(
      animation: _particleAnimation,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(
            progress: _particleAnimation.value,
            isDark: isDark,
          ),
          size: MediaQuery.of(context).size,
        );
      },
    );
  }
  
  Widget _buildConceptualClock() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _rotationAnimation,
        _scaleAnimation,
        _fadeAnimation,
      ]),
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: SizedBox(
              width: 220,
              height: 220,
              child: CustomPaint(
                painter: ConceptualClockPainter(
                  rotation: _rotationAnimation.value,
                  progress: _particleAnimation.value,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildTextContent({required bool isDark}) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          children: [
            Text(
              'مگاتایم',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textLight : AppColors.textDark,
                letterSpacing: -0.5,
                shadows: [
                  Shadow(
                    color: AppColors.primary,
                    blurRadius: 30,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spacingSM),
            Text(
              'مدیریت هوشمند زمان',
              style: TextStyle(
                fontSize: AppDimensions.fontSizeMD,
                color: isDark ? AppColors.textGrayLight : AppColors.textGray,
                fontWeight: FontWeight.w400,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLoadingIndicator({required bool isDark}) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 2.5,
              strokeCap: StrokeCap.round,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMD),
          Text(
            'در حال بارگذاری...',
            style: TextStyle(
              fontSize: AppDimensions.fontSizeSM,
              color: isDark ? AppColors.textGrayLight : AppColors.textGray,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildVersion({required bool isDark}) {
    return Positioned(
      bottom: AppDimensions.spacingLG,
      left: 0,
      right: 0,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Text(
            'نسخه ${AppConfig.appVersion}',
            style: TextStyle(
              fontSize: AppDimensions.fontSizeXS,
              color: isDark 
                  ? AppColors.textGray.withValues(alpha: 0.3)
                  : AppColors.textGrayLight.withValues(alpha: 0.3),
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}

// ============ Painter ذرات پس‌زمینه ============
class ParticlePainter extends CustomPainter {
  final double progress;
  final bool isDark;
  
  ParticlePainter({
    required this.progress,
    required this.isDark,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(42);
    final particleCount = 50;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2.5;
    
    for (int i = 0; i < particleCount; i++) {
      final angle = random.nextDouble() * 2 * 3.14159;
      final distance = random.nextDouble() * radius;
      final x = center.dx + distance * cos(angle + progress * 0.5);
      final y = center.dy + distance * sin(angle + progress * 0.5);
      
      final size_ = random.nextDouble() * 3 + 1;
      final opacity = (0.2 + 0.3 * (1 - distance / radius)) * (0.5 + 0.5 * sin(progress * 10 + i));
      
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = AppColors.primary.withValues(alpha: opacity);
      
      canvas.drawCircle(Offset(x, y), size_, paint);
    }
  }
  
  @override
  bool shouldRepaint(ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isDark != isDark;
  }
}

// ============ Painter ساعت مفهومی ============
class ConceptualClockPainter extends CustomPainter {
  final double rotation;
  final double progress;
  
  ConceptualClockPainter({
    required this.rotation,
    required this.progress,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // حلقه‌های متحدالمرکز
    for (int i = 0; i < 8; i++) {
      final ringRadius = radius - (i * 12);
      final ringOpacity = 0.1 + (0.05 * (8 - i));
      
      final ringPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = AppColors.primary.withValues(alpha: ringOpacity);
      
      canvas.drawCircle(center, ringRadius, ringPaint);
    }
    
    // حلقه اصلی در حال چرخش
    final mainRingPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = AppColors.primary.withValues(alpha: 0.6);
    
    canvas.drawCircle(center, radius - 20, mainRingPaint);
    
    // نقطه‌های متحرک روی حلقه
    final dotCount = 12;
    for (int i = 0; i < dotCount; i++) {
      final angle = (i / dotCount) * 2 * 3.14159 + rotation;
      final dotRadius = radius - 20;
      final x = center.dx + dotRadius * cos(angle);
      final y = center.dy + dotRadius * sin(angle);
      
      final isActive = i % 3 == 0;
      final dotPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = isActive
            ? AppColors.primary
            : AppColors.primary.withValues(alpha: 0.3);
      
      canvas.drawCircle(Offset(x, y), isActive ? 6 : 3, dotPaint);
    }
    
    // عقربه‌های مفهومی
    final hourAngle = rotation * 0.5;
    final minuteAngle = rotation * 2;
    
    // عقربه ساعت
    final hourPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..color = AppColors.primary.withValues(alpha: 0.8);
    
    final hourX = center.dx + (radius * 0.4) * cos(hourAngle);
    final hourY = center.dy + (radius * 0.4) * sin(hourAngle);
    canvas.drawLine(center, Offset(hourX, hourY), hourPaint);
    
    // عقربه دقیقه
    final minutePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..color = AppColors.primaryLight.withValues(alpha: 0.6);
    
    final minuteX = center.dx + (radius * 0.6) * cos(minuteAngle);
    final minuteY = center.dy + (radius * 0.6) * sin(minuteAngle);
    canvas.drawLine(center, Offset(minuteX, minuteY), minutePaint);
    
    // ذرات داخل ساعت
    final random = Random(123);
    for (int i = 0; i < 20; i++) {
      final angle = random.nextDouble() * 2 * 3.14159;
      final distance = random.nextDouble() * (radius - 30);
      final x = center.dx + distance * cos(angle + progress * 0.3);
      final y = center.dy + distance * sin(angle + progress * 0.3);
      
      final particlePaint = Paint()
        ..style = PaintingStyle.fill
        ..color = AppColors.primary.withValues(alpha: 0.15 + 0.1 * sin(progress * 5 + i));
      
      canvas.drawCircle(Offset(x, y), 1.5, particlePaint);
    }
    
    // مرکز
    final centerPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.primary;
    
    canvas.drawCircle(center, 8, centerPaint);
    
    // سایه مرکز
    final shadowPaint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20)
      ..color = AppColors.primary.withValues(alpha: 0.3);
    
    canvas.drawCircle(center, 20, shadowPaint);
    
    // خطوط نوری
    final lightCount = 24;
    for (int i = 0; i < lightCount; i++) {
      final angle = (i / lightCount) * 2 * 3.14159 + rotation * 0.1;
      final innerRadius = radius - 15;
      final outerRadius = radius - 8;
      
      final isActive = i % 2 == 0;
      final lightPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = isActive ? 1.5 : 0.5
        ..color = AppColors.primary.withValues(
          alpha: isActive ? 0.3 + 0.2 * sin(progress * 3 + i) : 0.1,
        );
      
      final startX = center.dx + innerRadius * cos(angle);
      final startY = center.dy + innerRadius * sin(angle);
      final endX = center.dx + outerRadius * cos(angle);
      final endY = center.dy + outerRadius * sin(angle);
      
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), lightPaint);
    }
    
    // هاله دور ساعت
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30)
      ..color = AppColors.primary.withValues(alpha: 0.1);
    
    canvas.drawCircle(center, radius - 10, glowPaint);
  }
  
  @override
  bool shouldRepaint(ConceptualClockPainter oldDelegate) {
    return oldDelegate.rotation != rotation || 
           oldDelegate.progress != progress;
  }
}