import 'package:flutter/material.dart';

class IsharaColors {
  // Heritage Royal & Accessible Contrast Tokens (WCAG AAA)
  static const Color primaryTeal = Color(0xFF0E4D48); // Deep Royal Jade Teal
  static const Color tealSurface = Color(0xFF165A54);
  static const Color tealLight = Color(0xFF1F7A72);
  static const Color tealSoft = Color(0xFFE6F0EF);

  // Accents
  static const Color royalGold = Color(0xFFF4A261); // Warm Solar Gold/Amber
  static const Color accentAmber = Color(0xFFF4A261); // Alias for compatibility
  static const Color goldLight = Color(0xFFFFEAD1);
  static const Color amberLight = Color(0xFFFFEAD1); // Alias for compatibility
  static const Color terracotta = Color(0xFFE05A47); // Heritage Terracotta
  static const Color terracottaSoft = Color(0xFFFDEEEB);

  // Studio & Canvases
  static const Color studioBackdrop = Color(0xFF202938); // Melanin-Neutral Hand Canvas
  static const Color paperCanvas = Color(0xFFFAF9F6); // Shantiniketan Paper
  static const Color bgLight = Color(0xFFFAF9F6); // Alias for compatibility
  static const Color cardLight = Colors.white;
  static const Color textDark = Color(0xFF121826);
  static const Color textMuted = Color(0xFF64748B);

  // Dark Mode Tokens (OLED Ready)
  static const Color obsidianDark = Color(0xFF0D1117);
  static const Color cardDark = Color(0xFF161B22);
  static const Color textLight = Color(0xFFF1F5F9);

  // Semantic
  static const Color success = Color(0xFF15803D);
  static const Color error = Color(0xFFB91C1C);
}

class IsharaTheme {
  static const String fontBengali = 'HindSiliguri';

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: fontBengali,
      colorScheme: ColorScheme.fromSeed(
        seedColor: IsharaColors.primaryTeal,
        primary: IsharaColors.primaryTeal,
        secondary: IsharaColors.royalGold,
        surface: IsharaColors.paperCanvas,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: IsharaColors.paperCanvas,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: fontBengali,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: IsharaColors.textDark,
          letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(
          fontFamily: fontBengali,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: IsharaColors.textDark,
          height: 1.5,
        ),
        bodyLarge: TextStyle(
          fontFamily: fontBengali,
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: IsharaColors.textDark,
          height: 1.6,
        ),
        bodyMedium: TextStyle(
          fontFamily: fontBengali,
          fontSize: 13,
          color: IsharaColors.textMuted,
          height: 1.5,
        ),
      ),
      cardTheme: const CardThemeData(
        color: IsharaColors.cardLight,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: IsharaColors.paperCanvas,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: fontBengali,
          color: IsharaColors.textDark,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: IsharaColors.textDark),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: IsharaColors.primaryTeal,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52), // Strict Ergonomic Touch Target (>= 48dp)
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontFamily: fontBengali,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}
