import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Dark Space Obsidian Backgrounds
  static const Color bgDarkStart = Color(0xFF080B11);
  static const Color bgDarkEnd = Color(0xFF0F172A);

  // High-Vibrancy Accent Colors
  static const Color primaryCyan = Color(0xFF00F2FE);
  static const Color primaryPurple = Color(0xFF8B5CF6);
  static const Color secondaryCyan = Color(0xFF06B6D4);
  static const Color secondaryPurple = Color(0xFFD946EF);
  static const Color emeraldGreen = Color(0xFF00FF87);
  static const Color amberOrange = Color(0xFFF59E0B);

  // Text Colors (Slate Palette)
  static const Color textPrimary = Color(0xFFF8FAFC); // Slate 50
  static const Color textSecondary = Color(0xFF94A3B8); // Slate 400
  static const Color textMuted = Color(0xFF64748B); // Slate 500

  // Glassmorphic Surface Configuration
  static const Color glassBg = Color(0x0CFFFFFF); // 5% white overlay
  static const Color glassBgDark = Color(0x1F000000); // 12% black overlay
  static const Color glassBorder = Color(0x1AFFFFFF); // 10% white border
  static const Color glassBorderGlow = Color(
    0x3300F2FE,
  ); // 20% Cyan glow border

  // Gradients
  static const Gradient primaryGradient = LinearGradient(
    colors: [primaryCyan, primaryPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient secondaryGradient = LinearGradient(
    colors: [secondaryCyan, secondaryPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient textGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFCBD5E1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient accentTextGradient = LinearGradient(
    colors: [primaryCyan, emeraldGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient darkBgGradient = LinearGradient(
    colors: [bgDarkStart, bgDarkEnd],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Glow Shadows
  static List<BoxShadow> cyanGlowShadow({
    double blur = 20,
    double opacity = 0.25,
  }) {
    return [
      BoxShadow(
        color: primaryCyan.withValues(alpha: opacity),
        blurRadius: blur,
        spreadRadius: -2,
        offset: const Offset(0, 0),
      ),
    ];
  }

  static List<BoxShadow> purpleGlowShadow({
    double blur = 20,
    double opacity = 0.25,
  }) {
    return [
      BoxShadow(
        color: primaryPurple.withValues(alpha: opacity),
        blurRadius: blur,
        spreadRadius: -2,
        offset: const Offset(0, 0),
      ),
    ];
  }
}
