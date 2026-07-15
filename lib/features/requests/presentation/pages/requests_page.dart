import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

class RequestsPage extends StatelessWidget {
  const RequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(AppDimensions.spacingMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '📝 درخواست‌های من',
                style: TextStyle(
                  fontSize: AppDimensions.fontSizeXL,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textLight : AppColors.textDark,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingMD,
                  vertical: AppDimensions.spacingSM,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                ),
                child: const Text(
                  '+ جدید',
                  style: TextStyle(
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingMD),
          Text(
            'درخواست‌های ثبت شده',
            style: TextStyle(
              fontSize: AppDimensions.fontSizeMD,
              color: isDark ? AppColors.textGrayLight : AppColors.textGray,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingLG),
          _buildRequestItem(
            isDark: isDark,
            title: 'مرخصی استعلاجی',
            date: '۱۴۰۴/۰۴/۲۰',
            status: 'تایید شده',
            statusColor: AppColors.success,
          ),
          _buildRequestItem(
            isDark: isDark,
            title: 'مأموریت کاری',
            date: '۱۴۰۴/۰۴/۱۸',
            status: 'در انتظار',
            statusColor: AppColors.warning,
          ),
          _buildRequestItem(
            isDark: isDark,
            title: 'اضافه‌کاری',
            date: '۱۴۰۴/۰۴/۱۵',
            status: 'رد شده',
            statusColor: AppColors.error,
          ),
          _buildRequestItem(
            isDark: isDark,
            title: 'تعویض شیفت',
            date: '۱۴۰۴/۰۴/۱۲',
            status: 'تایید شده',
            statusColor: AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildRequestItem({
    required bool isDark,
    required String title,
    required String date,
    required String status,
    required Color statusColor,
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
                  date,
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