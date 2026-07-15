import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/navigation_item.dart';

class CustomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<NavigationItem> items;
  
  const CustomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    
    // ===== اندازه‌های ریسپانسیو =====
    final isSmallScreen = screenWidth < 360;
    final isTablet = screenWidth >= 600;
    
    final barHeight = isSmallScreen ? 56.0 : (isTablet ? 72.0 : 64.0);
    final iconSize = isSmallScreen ? 20.0 : (isTablet ? 28.0 : 24.0);
    final fontSize = isSmallScreen ? 8.0 : (isTablet ? 12.0 : 10.0);
    final fabSize = isSmallScreen ? 48.0 : (isTablet ? 64.0 : 56.0);
    final fabIconSize = isSmallScreen ? 22.0 : (isTablet ? 30.0 : 26.0);
    
    // ✅ حاشیه‌های ریسپانسیو برای جلوگیری از خروج آیتم آخر
    final horizontalMargin = isSmallScreen ? 8.0 : (isTablet ? 32.0 : 16.0);
    final borderRadius = isSmallScreen ? 20.0 : (isTablet ? 40.0 : 32.0);
    final itemWidth = (screenWidth - (horizontalMargin * 2)) / widget.items.length;
    
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: horizontalMargin,
        vertical: 12,
      ),
      height: barHeight + 30,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // ===== نوار اصلی =====
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: barHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          const Color(0xFF1A2332),
                          const Color(0xFF0F1729),
                          const Color(0xFF1A2332),
                        ]
                      : [
                          Colors.white.withValues(alpha: 0.95),
                          Colors.white,
                          Colors.white.withValues(alpha: 0.95),
                        ],
                ),
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.black.withValues(alpha: 0.04),
                  width: 0.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.5)
                        : Colors.black.withValues(alpha: 0.08),
                    blurRadius: isTablet ? 40 : 30,
                    offset: const Offset(0, 8),
                    spreadRadius: isTablet ? 15 : 10,
                  ),
                  BoxShadow(
                    color: isDark
                        ? AppColors.primary.withValues(alpha: 0.08)
                        : AppColors.primary.withValues(alpha: 0.04),
                    blurRadius: isTablet ? 50 : 40,
                    offset: const Offset(0, 12),
                    spreadRadius: isTablet ? 25 : 20,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(widget.items.length, (index) {
                  final isActive = widget.currentIndex == index;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => widget.onTap(index),
                      child: Container(
                        height: barHeight,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (!isActive) ...[
                              Icon(
                                widget.items[index].icon,
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.4)
                                    : Colors.grey.shade500,
                                size: iconSize,
                              ),
                              if (!isSmallScreen) ...[
                                const SizedBox(height: 2),
                                Text(
                                  widget.items[index].label,
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.3)
                                        : Colors.grey.shade400,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          
          // ===== گوی آبی (FAB) =====
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutCubic,
            bottom: barHeight - fabSize / 2,
            left: (widget.currentIndex * itemWidth) + (itemWidth - fabSize) / 2,
            child: Container(
              width: fabSize,
              height: fabSize,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF4F8CFF),
                    AppColors.primary,
                    AppColors.primaryDark,
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: fabSize * 0.4,
                    spreadRadius: fabSize * 0.15,
                  ),
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: fabSize * 0.8,
                    spreadRadius: fabSize * 0.3,
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  widget.items[widget.currentIndex].icon,
                  color: Colors.white,
                  size: fabIconSize,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}