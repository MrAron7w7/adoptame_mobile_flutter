import 'package:adoptme/shared/theme/app_color.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // Light Mode
  static ThemeData get lightMode => ThemeData(
        scaffoldBackgroundColor: AppColor.surface,
        colorScheme: const ColorScheme.light(
          surface: AppColor.surface,
          primary: AppColor.primary,
          secondary: AppColor.secondary,
          tertiary: AppColor.tertiary,
          inversePrimary: AppColor.inversePrimary,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColor.surface,
          scrolledUnderElevation: 0.0,
        ),
      );

  // Dark Mode
  static ThemeData get darkMode => ThemeData(
        scaffoldBackgroundColor: AppColor.surfaceDark,
        colorScheme: const ColorScheme.dark(
          surface: AppColor.surfaceDark,
          primary: AppColor.primaryDark,
          secondary: AppColor.secondaryDark,
          tertiary: AppColor.tertiaryDark,
          inversePrimary: AppColor.inversePrimaryDark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColor.surfaceDark,
          scrolledUnderElevation: 0.0,
        ),
      );
}
