import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../colors/app_color.dart';
import '../dimensions/Dimension_app.dart';

/// Application theme configuration.
/// High-contrast, accessible design for non-technical users.
class AppTheme {
  AppTheme._();

  /// Light theme for the application.
  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.cairoTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColor.primaryColor,
      scaffoldBackgroundColor: AppColor.backgroundColor,
      colorScheme: const ColorScheme.light(
        primary: AppColor.primaryColor,
        onPrimary: AppColor.textOnPrimary,
        secondary: AppColor.accentColor,
        onSecondary: AppColor.textOnPrimary,
        surface: AppColor.surfaceColor,
        onSurface: AppColor.textPrimary,
        error: AppColor.errorColor,
        onError: AppColor.textOnPrimary,
      ),

      // ─── AppBar ───AppColor.
      appBarTheme: AppBarTheme(
        backgroundColor: AppColor.primaryColor,
        foregroundColor: AppColor.textOnPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: baseTextTheme.titleLarge?.copyWith(
          color: AppColor.textOnPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),

      // ─── Cards ───
      cardTheme: CardThemeData(
        color: AppColor.cardColor,
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimension.cardRadius),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: Dimension.spacingMd,
          vertical: Dimension.spacingSm,
        ),
      ),

      // ─── Elevated Buttons (Primary Actions) ───
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primaryColor,
          foregroundColor: AppColor.textOnPrimary,
          minimumSize: const Size(double.infinity, Dimension.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimension.borderRadius),
          ),
          textStyle: baseTextTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
          elevation: 2,
        ),
      ),

      // ─── Outlined Buttons (Secondary Actions) ───
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColor.primaryColor,
          minimumSize: const Size(double.infinity, Dimension.buttonHeight),
          side: const BorderSide(color: AppColor.primaryColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimension.borderRadius),
          ),
          textStyle: baseTextTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),

      // ─── Text Buttons ───
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColor.primaryColor,
          textStyle: baseTextTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ─── Input Fields ───
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Dimension.spacingMd,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimension.borderRadius),
          borderSide: const BorderSide(color: AppColor.dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimension.borderRadius),
          borderSide: const BorderSide(color: AppColor.dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimension.borderRadius),
          borderSide: const BorderSide(color: AppColor.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimension.borderRadius),
          borderSide: const BorderSide(color: AppColor.errorColor, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimension.borderRadius),
          borderSide: const BorderSide(color: AppColor.errorColor, width: 2),
        ),
        labelStyle: baseTextTheme.bodyLarge?.copyWith(
          color: AppColor.textSecondary,
          fontSize: 16,
        ),
        hintStyle: baseTextTheme.bodyLarge?.copyWith(
          color: AppColor.textSecondary.withValues(alpha: 0.6),
          fontSize: 16,
        ),
        errorStyle: baseTextTheme.bodyMedium?.copyWith(
          color: AppColor.errorColor,
          fontSize: 14,
        ),
      ),

      // ─── Bottom Navigation ───
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColor.surfaceColor,
        selectedItemColor: AppColor.primaryColor,
        unselectedItemColor: AppColor.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: baseTextTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
        unselectedLabelStyle: baseTextTheme.bodySmall?.copyWith(
          fontSize: 12,
        ),
      ),

      // ─── Navigation Rail (Desktop) ───
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: AppColor.surfaceColor,
        selectedIconTheme: const IconThemeData(
          color: AppColor.primaryColor,
          size: Dimension.iconSizeLarge,
        ),
        unselectedIconTheme: const IconThemeData(
          color: AppColor.textSecondary,
          size: Dimension.iconSizeMedium,
        ),
        selectedLabelTextStyle: baseTextTheme.bodyMedium?.copyWith(
          color: AppColor.primaryColor,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelTextStyle: baseTextTheme.bodyMedium?.copyWith(
          color: AppColor.textSecondary,
        ),
      ),

      // ─── Floating Action Button ───
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColor.accentColor,
        foregroundColor: AppColor.textOnPrimary,
        elevation: 4,
        shape: CircleBorder(),
      ),

      // ─── Divider ───
      dividerTheme: const DividerThemeData(
        color: AppColor.dividerColor,
        thickness: 1,
        space: 1,
      ),

      // ─── Text Theme ───
      textTheme: baseTextTheme.copyWith(
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(
          color: AppColor.textPrimary,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(
          color: AppColor.textPrimary,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: baseTextTheme.titleLarge?.copyWith(
          color: AppColor.textPrimary,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: baseTextTheme.titleMedium?.copyWith(
          color: AppColor.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          color: AppColor.textPrimary,
          fontSize: 16,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          color: AppColor.textSecondary,
        ),
        labelLarge: baseTextTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
