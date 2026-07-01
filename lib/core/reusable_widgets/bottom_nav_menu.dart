import 'package:flutter/material.dart';
import 'package:vidya_setu/core/theme/app_colors.dart';

class BottomNavMenu {
  // --- Dimensions & Spacing ---
  static const double barHeight = 72.0;
  static const double barRadius = 24.0;
  static const double bottomPadding = 20.0;
  static const double horizontalPadding = 16.0;
  static const double itemRadius = 16.0;
  static const double itemInternalPadding = 10.0;

  // --- Animation Timings ---
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration textAnimationDuration = Duration(milliseconds: 200);
  static const Curve animationCurve = Curves.easeInOut;

  // --- Theme Colors ---
  static const Color navBgColor = AppColors.primary;
  static const Color activeColor = AppColors.white;
  static final Color inactiveColor = Colors.white.withOpacity(0.6);
  static final Color activeBgHighlight = Colors.white.withOpacity(0.15);

  // --- Shadow Layer Config ---
  static List<BoxShadow> get barShadow => [
    BoxShadow(
      color: navBgColor.withOpacity(0.3),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];
}
