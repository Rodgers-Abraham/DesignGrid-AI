import 'package:flutter/material.dart';

class AppColors {
  // Primary background: Ultra-deep charcoal/matte black
  static const Color background = Color(0xFF0D0E12);
  
  // Interactive accents: Bright amber/yellow
  static const Color primaryAmber = Color(0xFFFFC72C);
  static const Color accentAmber = Color(0xFFFFB800);
  
  // Neutral colors
  static const Color surface = Color(0xFF1A1C23);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF8E8E93);

  // Light mode specific (to be used in AppTheme)
  static const Color textPrimaryLight = Color(0xFF0D0E12);
  static const Color textSecondaryLight = Color(0xFF48484A);
  static const Color surfaceLight = Colors.white;
  static const Color backgroundLight = Color(0xFFF8F9FA);
  
  // Error
  static const Color error = Color(0xFFFF453A);
}
