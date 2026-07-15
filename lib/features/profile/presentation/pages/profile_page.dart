import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/config/routes.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  String _userName = 'کاربر';
  String _employeeCode = '۱۲۳۴۵';
  String _email = 'user@company.com';
  String _phone = '۰۹۱۲۳۴۵۶۷۸۹';
  String _department = 'منابع انسانی';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await _authService.getSavedUser();
    if (user != null) {
      setState(() {
        _userName = user.displayName;
        _employeeCode = user.employeeCode;
        _phone = user.mobile ?? '۰۹۱۲۳۴۵۶۷۸۹';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacingMD),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAvatar(isDark),
            const SizedBox(height: AppDimensions.spacingMD),
            Text(
              _userName,
              style: TextStyle(
                fontSize: AppDimensions.fontSizeXL,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textLight : AppColors.textDark,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingSM),
            Text(
              'مدیر منابع انسانی',
              style: TextStyle(
                fontSize: AppDimensions.fontSizeMD,
                color: isDark ? AppColors.textGrayLight : AppColors.textGray,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingXL),
            _buildInfoCard(isDark),
            const SizedBox(height: AppDimensions.spacingXL),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(bool isDark) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: AppColors.primary.withValues(alpha: 0.2),
          child: Text(
            _userName.isNotEmpty ? _userName[0].toUpperCase() : 'U',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.edit,
              color: Colors.white,
              size: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spacingLG),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.backgroundDarkCard
            : AppColors.backgroundLightCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? AppColors.borderDark
              : AppColors.borderLight,
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          _buildInfoItem(
            isDark: isDark,
            icon: Icons.badge,
            label: 'کد پرسنلی',
            value: _employeeCode,
          ),
          _buildInfoItem(
            isDark: isDark,
            icon: Icons.email,
            label: 'ایمیل',
            value: _email,
          ),
          _buildInfoItem(
            isDark: isDark,
            icon: Icons.phone,
            label: 'شماره تماس',
            value: _phone,
          ),
          _buildInfoItem(
            isDark: isDark,
            icon: Icons.business,
            label: 'دپارتمان',
            value: _department,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required bool isDark,
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(width: AppDimensions.spacingMD),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: AppDimensions.fontSizeXS,
                  color: isDark ? AppColors.textGrayLight : AppColors.textGray,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: AppDimensions.fontSizeSM,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textLight : AppColors.textDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return ElevatedButton(
      onPressed: () async {
        await _authService.logout();
        if (mounted) {
          Navigator.pushReplacementNamed(context, Routes.login);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.error,
        foregroundColor: AppColors.textLight,
        minimumSize: const Size(200, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        ),
      ),
      child: const Text('خروج از حساب'),
    );
  }
}