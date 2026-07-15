import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_navigation_bar.dart';
import '../../../../core/models/navigation_item.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart';
import '../../../requests/presentation/pages/requests_page.dart';
import '../../../attendance/presentation/pages/attendance_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late final PageController _pageController;
  
  late final List<NavigationItem> _navItems = const [
    NavigationItem(icon: Icons.home_rounded, label: 'خانه'),
    NavigationItem(icon: Icons.dashboard_rounded, label: 'کارتابل'),
    NavigationItem(icon: Icons.description_rounded, label: 'درخواست‌ها'),
    NavigationItem(icon: Icons.fingerprint_rounded, label: 'حضور و غیاب'),
    NavigationItem(icon: Icons.person_rounded, label: 'پروفایل'),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: _navItems[_currentIndex].label,
              onMenuTap: () {},
              onSearchTap: () {},
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                physics: const BouncingScrollPhysics(),
                children: const [
                  HomeContentPage(),
                  DashboardPage(),
                  RequestsPage(),
                  AttendancePage(),
                  ProfilePage(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
          );
        },
        items: _navItems,
      ),
    );
  }
}

// ============================================================
// ===== صفحه محتوای خانه (جدا) =====
// ============================================================
class HomeContentPage extends StatefulWidget {
  const HomeContentPage({super.key});

  @override
  State<HomeContentPage> createState() => _HomeContentPageState();
}

class _HomeContentPageState extends State<HomeContentPage> {
  String _userName = 'کاربر';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // TODO: دریافت از AuthService
    setState(() {
      _userName = 'علی رضایی';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(AppDimensions.spacingMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeCard(isDark),
          const SizedBox(height: AppDimensions.spacingXL),
          _buildStatsSection(isDark),
          const SizedBox(height: AppDimensions.spacingXL),
          _buildRecentActivities(isDark),
        ],
      ),
    );
  }

  // ===== کارت خوش‌آمدگویی =====
  Widget _buildWelcomeCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spacingXL),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryLight, Color(0xFF60A5FA)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.textLight.withValues(alpha: 0.2),
                child: Text(
                  _userName.isNotEmpty ? _userName[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textLight,
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.spacingMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'سلام $_userName 👋',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textLight,
                      ),
                    ),
                    const Text(
                      'به پنل مدیریت خوش آمدید',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingLG),
          Row(
            children: [
              _buildQuickAction(
                icon: Icons.fingerprint,
                label: 'ثبت تردد',
                color: AppColors.textLight,
              ),
              _buildQuickAction(
                icon: Icons.beach_access,
                label: 'درخواست مرخصی',
                color: AppColors.textLight,
              ),
              _buildQuickAction(
                icon: Icons.timer,
                label: 'کارکرد امروز',
                color: AppColors.textLight,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.textLight.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.textLight.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textLight,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ===== بخش آمار =====
  Widget _buildStatsSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '📊 آمار امروز',
          style: TextStyle(
            fontSize: AppDimensions.fontSizeLG,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textLight : AppColors.textDark,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMD),
        Row(
          children: [
            _buildStatCard(
              title: 'حضور',
              value: '۱۲ نفر',
              icon: Icons.fingerprint,
              color: AppColors.success,
              isDark: isDark,
            ),
            const SizedBox(width: AppDimensions.spacingMD),
            _buildStatCard(
              title: 'مرخصی',
              value: '۳ نفر',
              icon: Icons.beach_access,
              color: AppColors.warning,
              isDark: isDark,
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingMD),
        Row(
          children: [
            _buildStatCard(
              title: 'ماموریت',
              value: '۲ نفر',
              icon: Icons.flight_takeoff,
              color: AppColors.info,
              isDark: isDark,
            ),
            const SizedBox(width: AppDimensions.spacingMD),
            _buildStatCard(
              title: 'غیبت',
              value: '۱ نفر',
              icon: Icons.person_off,
              color: AppColors.error,
              isDark: isDark,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacingMD),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.backgroundDarkCard
              : AppColors.backgroundLightCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? AppColors.borderDark
                : AppColors.borderLight,
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? AppColors.shadow
                  : AppColors.shadow,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: AppDimensions.spacingMD),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: AppDimensions.fontSizeXL,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textLight : AppColors.textDark,
                    ),
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: AppDimensions.fontSizeXS,
                      color: isDark ? AppColors.textGrayLight : AppColors.textGray,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== فعالیت‌های اخیر =====
  Widget _buildRecentActivities(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '🕐 فعالیت‌های اخیر',
          style: TextStyle(
            fontSize: AppDimensions.fontSizeLG,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textLight : AppColors.textDark,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMD),
        _buildActivityItem(
          isDark: isDark,
          icon: Icons.fingerprint,
          title: 'ثبت تردد',
          subtitle: 'علی رضایی - ساعت ۰۸:۳۰',
          time: '۲ دقیقه پیش',
        ),
        _buildActivityItem(
          isDark: isDark,
          icon: Icons.beach_access,
          title: 'درخواست مرخصی',
          subtitle: 'سارا احمدی - ۲ روز',
          time: '۱۵ دقیقه پیش',
        ),
        _buildActivityItem(
          isDark: isDark,
          icon: Icons.check_circle,
          title: 'تایید مأموریت',
          subtitle: 'رضا کریمی - تهران',
          time: '۱ ساعت پیش',
        ),
      ],
    );
  }

  Widget _buildActivityItem({
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spacingMD),
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingSM),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.backgroundDarkCard
            : AppColors.backgroundLightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.borderDark
              : AppColors.borderLight,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: AppDimensions.spacingMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppDimensions.fontSizeSM,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textLight : AppColors.textDark,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: AppDimensions.fontSizeXS,
                    color: isDark ? AppColors.textGrayLight : AppColors.textGray,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: AppDimensions.fontSizeXS,
              color: isDark ? AppColors.textGrayLight : AppColors.textGray,
            ),
          ),
        ],
      ),
    );
  }
}