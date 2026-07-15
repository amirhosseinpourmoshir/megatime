import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  String get _todayDate {
    final now = DateTime.now();
    final persianMonths = [
      'فروردین', 'اردیبهشت', 'خرداد', 'تیر', 'مرداد', 'شهریور',
      'مهر', 'آبان', 'آذر', 'دی', 'بهمن', 'اسفند'
    ];
    final month = persianMonths[now.month - 1];
    return '${now.day} $month ${now.year}';
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
          Text(
            '🕐 حضور و غیاب',
            style: TextStyle(
              fontSize: AppDimensions.fontSizeXL,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textLight : AppColors.textDark,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMD),
          Text(
            'امروز: $_todayDate',
            style: TextStyle(
              fontSize: AppDimensions.fontSizeMD,
              color: isDark ? AppColors.textGrayLight : AppColors.textGray,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingLG),
          _buildCheckInCard(isDark),
          const SizedBox(height: AppDimensions.spacingXL),
          _buildHistorySection(isDark),
        ],
      ),
    );
  }

  Widget _buildCheckInCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spacingXL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.success,
            AppColors.success.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: AppColors.textLight,
            size: 48,
          ),
          const SizedBox(height: AppDimensions.spacingSM),
          Text(
            'ثبت تردد موفق',
            style: TextStyle(
              fontSize: AppDimensions.fontSizeLG,
              fontWeight: FontWeight.w700,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSM),
          Text(
            'ساعت ورود: ۰۸:۳۰',
            style: TextStyle(
              fontSize: AppDimensions.fontSizeMD,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMD),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingXL,
              vertical: AppDimensions.spacingMD,
            ),
            decoration: BoxDecoration(
              color: AppColors.textLight.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'ثبت خروج',
              style: TextStyle(
                color: AppColors.textLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '📅 تاریخچه حضور',
          style: TextStyle(
            fontSize: AppDimensions.fontSizeLG,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textLight : AppColors.textDark,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMD),
        _buildHistoryItem(
          isDark: isDark,
          date: '۱۴۰۴/۰۴/۲۰',
          checkIn: '۰۸:۳۰',
          checkOut: '۱۷:۰۰',
          status: 'حاضر',
          statusColor: AppColors.success,
        ),
        _buildHistoryItem(
          isDark: isDark,
          date: '۱۴۰۴/۰۴/۱۹',
          checkIn: '۰۸:۴۵',
          checkOut: '۱۷:۱۵',
          status: 'حاضر',
          statusColor: AppColors.success,
        ),
        _buildHistoryItem(
          isDark: isDark,
          date: '۱۴۰۴/۰۴/۱۸',
          checkIn: '۰۹:۰۰',
          checkOut: '۱۶:۳۰',
          status: 'تأخیر',
          statusColor: AppColors.warning,
        ),
        _buildHistoryItem(
          isDark: isDark,
          date: '۱۴۰۴/۰۴/۱۷',
          checkIn: '-',
          checkOut: '-',
          status: 'غایب',
          statusColor: AppColors.error,
        ),
      ],
    );
  }

  Widget _buildHistoryItem({
    required bool isDark,
    required String date,
    required String checkIn,
    required String checkOut,
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
          const SizedBox(width: AppDimensions.spacingMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: TextStyle(
                    fontSize: AppDimensions.fontSizeSM,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textLight : AppColors.textDark,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'ورود: $checkIn',
                      style: TextStyle(
                        fontSize: AppDimensions.fontSizeXS,
                        color: isDark ? AppColors.textGrayLight : AppColors.textGray,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacingSM),
                    Text(
                      'خروج: $checkOut',
                      style: TextStyle(
                        fontSize: AppDimensions.fontSizeXS,
                        color: isDark ? AppColors.textGrayLight : AppColors.textGray,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}