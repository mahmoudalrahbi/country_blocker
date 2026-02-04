import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App color constants matching the design system
class AppColors {
  // Primary colors - Updated to match design specs
  static const primary = Color(0xFF2563EB); // Vivid Blue
  static const primaryHover = Color(0xFF1D4ED8);
  
  // Background colors - Updated to match design specs
  static const backgroundLight = Color(0xFFF6F6F8);
  static const backgroundDark = Color(0xFF0F172A); // Deep Navy/Charcoal
  static const surfaceDark = Color(0xFF1E293B); // Slate Gray (for cards)
  static const cardDark = Color(0xFF1E293B); // Same as surface for cards
  static const inputDark = Color(0xFF1E293B); // Same for inputs
  
  // Text colors - Updated to match design specs
  static const textPrimary = Color(0xFFFFFFFF); // White
  static const textSecondary = Color(0xFF94A3B8); // Muted Blue-Gray
  static const textTertiary = Color(0xFF64748B); // Darker muted gray
  
  // Status colors - Updated to match design specs
  static const success = Color(0xFF10B981); // Active Green
  static const systemInfo = Color(0xFF3B82F6); // System Info Blue
  static const error = Color(0xFFEF4444); // Danger/Delete
  static const warning = Color(0xFFF59E0B);
  
  // Border colors
  static const borderLight = Color(0xFFE5E7EB);
  static const borderDark = Color(0xFF334155); // Slightly lighter for borders
}

/// App theme configuration
class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color scheme
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.primary,
        surface: AppColors.surfaceDark,
        error: AppColors.error,
      ),
      
      // Scaffold background
      scaffoldBackgroundColor: AppColors.backgroundDark,
      
      // Card theme - Updated to match design specs (12-16px radius)
      cardTheme: const CardThemeData(
        color: AppColors.cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          side: BorderSide(
            color: Color(0x33334155), // Subtle border
            width: 1,
          ),
        ),
      ),
      
      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundDark.withOpacity(0.95),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      
      // Text theme - Updated to match design specs
      textTheme: TextTheme(
        // Headlines (H1): 24-28px, Bold, White (adjusted for mobile)
        displayLarge: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        displaySmall: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        // Section Headers (H2): 18-20px, Semi-Bold, White
        headlineLarge: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        headlineSmall: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        // Body Text: 14-16px, Regular, Muted Gray
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.textPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppColors.textSecondary,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: AppColors.textSecondary,
        ),
        // Button Text: 16px, Semi-Bold, White
        labelLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        // Micro-copy (Labels): Smaller for mobile, Bold, Uppercase, Muted Gray
        labelMedium: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondary,
          letterSpacing: 0.8,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondary,
          letterSpacing: 0.8,
        ),
      ),
      
      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: AppColors.primary.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.borderDark.withOpacity(0.5),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.borderDark.withOpacity(0.5),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: GoogleFonts.inter(
          color: AppColors.textTertiary,
          fontSize: 14,
        ),
        labelStyle: GoogleFonts.inter(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
      ),
      
      // Floating action button theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 8,
        shape: CircleBorder(),
      ),
      
      // Bottom navigation bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.backgroundDark.withOpacity(0.95),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
