import 'package:flutter/material.dart';

/// Centralized colors & styling constants, ported 1:1 from the original
/// `bg.css` (the stylesheet that is loaded last in index.html and defines
/// the actual visible "glassmorphism on animated gradient" design).
class AppColors {
  AppColors._();

  // Animated background gradient stops (body::before in bg.css).
  static const Color gradient1 = Color(0xFFEE7752);
  static const Color gradient2 = Color(0xFFE73C7E);
  static const Color gradient3 = Color(0xFF23A6D5);
  static const Color gradient4 = Color(0xFF23D5AB);
  static const Color backgroundFallback = Color(0xFF111827);

  // Glass card.
  static const Color cardBase = Color(0xFF1F2937); // rgba(31,41,55, .5)
  static const double cardOpacity = 0.5;
  static const Color cardBorder = Colors.white; // .2 opacity
  static const double cardBorderOpacity = 0.2;

  // Text.
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFD1D5DB);

  // Buttons.
  static const Color primaryBtn = Color(0xFF4F46E5); // indigo-600
  static const Color primaryBtnHover = Color(0xFF4338CA); // indigo-700
  static const Color secondaryBtnText = Color(0xFFE5E7EB);

  // Options / chapter list rows.
  static const Color rowBase = Colors.white; // 0.05 opacity background
  static const double rowBaseOpacity = 0.05;
  static const Color rowBorder = Colors.white; // 0.1 opacity
  static const double rowBorderOpacity = 0.1;

  // Correct / incorrect feedback (emerald-500 / red-500 family).
  static const Color correct = Color(0xFF10B981);
  static const Color incorrect = Color(0xFFEF4444);
  static const Color correctText = Color(0xFF6EE7B7);

  // Progress bar track.
  static const Color progressTrack = Color(0x4D000000); // rgba(0,0,0,.3)
}
