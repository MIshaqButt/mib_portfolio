import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mib_portfolio/core/constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor:
          Colors.transparent, // Background will be handled by parent gradient
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryCyan,
        secondary: AppColors.primaryPurple,
        surface: AppColors.bgDarkEnd,
        error: Colors.redAccent,
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
      ),

      // Typography with Google Fonts
      textTheme: TextTheme(
        displayLarge: GoogleFonts.outfit(
          fontSize: 64,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
          letterSpacing: -1.5,
        ),
        displayMedium: GoogleFonts.outfit(
          fontSize: 48,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
          letterSpacing: -1.0,
        ),
        displaySmall: GoogleFonts.outfit(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: -0.5,
        ),
        headlineLarge: GoogleFonts.outfit(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        headlineMedium: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        titleLarge: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleMedium: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
          height: 1.5,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
      ),

      // Scrollbar theme
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(
          AppColors.primaryCyan.withValues(alpha: 0.3),
        ),
        trackColor: WidgetStateProperty.all(Colors.transparent),
        thickness: WidgetStateProperty.all(8.0),
        radius: const Radius.circular(10),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.glassBorder,
        thickness: 1,
        space: 24,
      ),
    );
  }
}
