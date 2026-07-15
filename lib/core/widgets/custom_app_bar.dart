import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../theme/theme_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onMenuTap;
  final VoidCallback? onSearchTap;
  final List<Widget>? actions;
  final bool showLeading;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onMenuTap,
    this.onSearchTap,
    this.actions,
    this.showLeading = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      height: 100,
      padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF1A2332).withValues(alpha: 0.9),
                    const Color(0xFF0F1729).withValues(alpha: 0.9),
                  ]
                : [
                    Colors.white.withValues(alpha: 0.9),
                    Colors.white.withValues(alpha: 0.85),
                  ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.04),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.4)
                  : Colors.black.withValues(alpha: 0.06),
              blurRadius: 30,
              offset: const Offset(0, 8),
              spreadRadius: 5,
            ),
            BoxShadow(
              color: isDark
                  ? AppColors.primary.withValues(alpha: 0.06)
                  : AppColors.primary.withValues(alpha: 0.03),
              blurRadius: 40,
              offset: const Offset(0, 12),
              spreadRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            // ===== دکمه منو =====
            if (showLeading)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onMenuTap,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.menu_rounded,
                      color: isDark ? AppColors.textLight : AppColors.textDark,
                      size: 24,
                    ),
                  ),
                ),
              ),

            const SizedBox(width: 4),

            // ===== عنوان =====
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textLight : AppColors.textDark,
                  letterSpacing: -0.3,
                ),
              ),
            ),

            // ===== دکمه جستجو =====
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onSearchTap,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.search_rounded,
                    color: isDark ? AppColors.textGrayLight : AppColors.textGray,
                    size: 22,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 4),

            // ===== دکمه تعویض تم =====
            _buildThemeToggle(
              isDark: isDark,
              onToggle: () => themeProvider.toggleTheme(),
            ),

            if (actions != null) ...actions!,
          ],
        ),
      ),
    );
  }

  // ===== دکمه تعویض تم مدرن =====
  Widget _buildThemeToggle({
    required bool isDark,
    required VoidCallback onToggle,
  }) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
        width: 40,
        height: 22,
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFF1A2332), Color(0xFF0F1729)],
                )
              : const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFFE8EDF5), Color(0xFFF0F4FA)],
                ),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.06),
            width: 0.5,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOutCubic,
              alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 16,
                height: 16,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.primaryLight,
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    isDark ? Icons.nightlight_round : Icons.wb_sunny,
                    color: Colors.white,
                    size: 8,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}