import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(AppDimensions.spacingMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📋 کارتابل من',
            style: TextStyle(
              fontSize: AppDimensions.fontSizeXL,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textLight : AppColors.textDark,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMD),
          Text(
            'درخواست‌های نیازمند تایید',
            style: TextStyle(
              fontSize: AppDimensions.fontSizeMD,
              color: isDark ? AppColors.textGrayLight : AppColors.textGray,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingLG),
          _buildInboxCard(
            isDark: isDark,
            title: 'درخواست مرخصی',
            subtitle: 'علی رضایی - ۳ روز',
            status: 'در انتظار تایید',
            statusColor: AppColors.warning,
            icon: Icons.beach_access,
          ),
          _buildInboxCard(
            isDark: isDark,
            title: 'درخواست مأموریت',
            subtitle: 'سارا احمدی - تهران',
            status: 'در انتظار تایید',
            statusColor: AppColors.warning,
            icon: Icons.flight_takeoff,
          ),
          _buildInboxCard(
            isDark: isDark,
            title: 'درخواست اضافه‌کاری',
            subtitle: 'رضا کریمی - ۴ ساعت',
            status: 'نیاز به بررسی',
            statusColor: AppColors.info,
            icon: Icons.timer,
          ),
          _buildInboxCard(
            isDark: isDark,
            title: 'درخواست تعویض شیفت',
            subtitle: 'احمد حسینی',
            status: 'تایید شده',
            statusColor: AppColors.success,
            icon: Icons.swap_horiz,
          ),
        ],
      ),
    );
  }

  Widget _buildInboxCard({
    required bool isDark,
    required String title,
    required String subtitle,
    required String status,
    required Color statusColor,
    required IconData icon,
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
              color: statusColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: statusColor, size: 24),
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
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingSM,
              vertical: AppDimensions.spacingXXS,
            ),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 10,
                color: statusColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}