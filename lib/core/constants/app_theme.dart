import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_dimensions.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundLight, // سفید کامل
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.primaryLight,
      surface: AppColors.backgroundLightSurface,
      background: AppColors.backgroundLight, // سفید کامل
      error: AppColors.error,
      onPrimary: AppColors.textLight,
      onSecondary: AppColors.textLight,
      onSurface: AppColors.textDark,
      onBackground: AppColors.textDark,
      onError: AppColors.textLight,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: AppColors.backgroundLight, // سفید کامل
      foregroundColor: AppColors.textDark,
      titleTextStyle: TextStyle(
        fontSize: AppDimensions.fontSizeLG,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
      iconTheme: IconThemeData(
        color: AppColors.textDark,
        size: AppDimensions.iconLG,
      ),
    ),
    cardTheme: const CardThemeData(
      elevation: AppDimensions.elevationSM,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppDimensions.radiusMD)),
      ),
      color: AppColors.backgroundLightCard,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textLight,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        ),
        textStyle: const TextStyle(
          fontSize: AppDimensions.fontSizeMD,
          fontWeight: FontWeight.w600,
        ),
        elevation: AppDimensions.elevationSM,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: const TextStyle(
          fontSize: AppDimensions.fontSizeMD,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        ),
        textStyle: const TextStyle(
          fontSize: AppDimensions.fontSizeMD,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.backgroundLightSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        borderSide: const BorderSide(color: AppColors.borderLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        borderSide: const BorderSide(color: AppColors.borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        borderSide: const BorderSide(color: AppColors.primary, width: AppDimensions.borderWidthLG),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        borderSide: const BorderSide(color: AppColors.error, width: AppDimensions.borderWidthMD),
      ),
      contentPadding: const EdgeInsets.all(AppDimensions.spacingMD),
      hintStyle: const TextStyle(
        color: AppColors.textGray,
        fontSize: AppDimensions.fontSizeMD,
      ),
      labelStyle: const TextStyle(
        color: AppColors.textDark,
        fontSize: AppDimensions.fontSizeMD,
        fontWeight: FontWeight.w500,
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: AppDimensions.fontSizeXXXL,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
        letterSpacing: -0.5,
      ),
      headlineMedium: TextStyle(
        fontSize: AppDimensions.fontSizeXXL,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
        letterSpacing: -0.3,
      ),
      headlineSmall: TextStyle(
        fontSize: AppDimensions.fontSizeXL,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
      titleLarge: TextStyle(
        fontSize: AppDimensions.fontSizeLG,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
      titleMedium: TextStyle(
        fontSize: AppDimensions.fontSizeMD,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
      titleSmall: TextStyle(
        fontSize: AppDimensions.fontSizeSM,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
      bodyLarge: TextStyle(
        fontSize: AppDimensions.fontSizeMD,
        color: AppColors.textDark,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: AppDimensions.fontSizeSM,
        color: AppColors.textGray,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        fontSize: AppDimensions.fontSizeXS,
        color: AppColors.textGrayLight,
        height: 1.4,
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.borderLight,
      thickness: AppDimensions.borderWidthSM,
      space: AppDimensions.spacingMD,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppDimensions.radiusMD)),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundDark, // rgb(10,20,35)
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.primaryLight,
      surface: AppColors.backgroundDarkSurface,
      background: AppColors.backgroundDark, // rgb(10,20,35)
      error: AppColors.error,
      onPrimary: AppColors.textLight,
      onSecondary: AppColors.textLight,
      onSurface: AppColors.textLight,
      onBackground: AppColors.textLight,
      onError: AppColors.textLight,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: AppColors.backgroundDark, // rgb(10,20,35)
      foregroundColor: AppColors.textLight,
      titleTextStyle: TextStyle(
        fontSize: AppDimensions.fontSizeLG,
        fontWeight: FontWeight.w600,
        color: AppColors.textLight,
      ),
      iconTheme: IconThemeData(
        color: AppColors.textLight,
        size: AppDimensions.iconLG,
      ),
    ),
    cardTheme: const CardThemeData(
      elevation: AppDimensions.elevationSM,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppDimensions.radiusMD)),
      ),
      color: AppColors.backgroundDarkCard,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textLight,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        ),
        textStyle: const TextStyle(
          fontSize: AppDimensions.fontSizeMD,
          fontWeight: FontWeight.w600,
        ),
        elevation: AppDimensions.elevationSM,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: const TextStyle(
          fontSize: AppDimensions.fontSizeMD,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        ),
        textStyle: const TextStyle(
          fontSize: AppDimensions.fontSizeMD,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.backgroundDarkSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        borderSide: const BorderSide(color: AppColors.borderDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        borderSide: const BorderSide(color: AppColors.borderDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        borderSide: const BorderSide(color: AppColors.primary, width: AppDimensions.borderWidthLG),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        borderSide: const BorderSide(color: AppColors.error, width: AppDimensions.borderWidthMD),
      ),
      contentPadding: const EdgeInsets.all(AppDimensions.spacingMD),
      hintStyle: const TextStyle(
        color: AppColors.textGrayLight,
        fontSize: AppDimensions.fontSizeMD,
      ),
      labelStyle: const TextStyle(
        color: AppColors.textLight,
        fontSize: AppDimensions.fontSizeMD,
        fontWeight: FontWeight.w500,
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: AppDimensions.fontSizeXXXL,
        fontWeight: FontWeight.w700,
        color: AppColors.textLight,
        letterSpacing: -0.5,
      ),
      headlineMedium: TextStyle(
        fontSize: AppDimensions.fontSizeXXL,
        fontWeight: FontWeight.w700,
        color: AppColors.textLight,
        letterSpacing: -0.3,
      ),
      headlineSmall: TextStyle(
        fontSize: AppDimensions.fontSizeXL,
        fontWeight: FontWeight.w600,
        color: AppColors.textLight,
      ),
      titleLarge: TextStyle(
        fontSize: AppDimensions.fontSizeLG,
        fontWeight: FontWeight.w600,
        color: AppColors.textLight,
      ),
      titleMedium: TextStyle(
        fontSize: AppDimensions.fontSizeMD,
        fontWeight: FontWeight.w600,
        color: AppColors.textLight,
      ),
      titleSmall: TextStyle(
        fontSize: AppDimensions.fontSizeSM,
        fontWeight: FontWeight.w600,
        color: AppColors.textLight,
      ),
      bodyLarge: TextStyle(
        fontSize: AppDimensions.fontSizeMD,
        color: AppColors.textLight,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: AppDimensions.fontSizeSM,
        color: AppColors.textGrayLight,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        fontSize: AppDimensions.fontSizeXS,
        color: AppColors.textGray,
        height: 1.4,
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.borderDark,
      thickness: AppDimensions.borderWidthSM,
      space: AppDimensions.spacingMD,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppDimensions.radiusMD)),
      ),
    ),
  );
}