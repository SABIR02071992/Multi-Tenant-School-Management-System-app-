import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    primaryColor: AppColors.primary,

    scaffoldBackgroundColor:
    AppColors.background,

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      centerTitle: true,
    ),

    elevatedButtonTheme:
    ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor:
        AppColors.primary,
        foregroundColor:
        Colors.white,
        minimumSize:
        const Size(double.infinity, 50),
      ),
    ),

    inputDecorationTheme:
    const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  );
}