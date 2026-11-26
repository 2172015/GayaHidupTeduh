import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_theme.dart';
import 'app_widget_theme.dart';
import 'teduh_theme_extension.dart';

/// Titik masuk konfigurasi tema aplikasi yang menggabungkan [AppColors],
/// [AppTextTheme], [AppWidgetTheme], dan [TeduhThemeExtension].
class AppTheme {
  AppTheme._();

  /// Tema terang (*Light Theme*) utama yang dipasang pada [MaterialApp.theme].
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTextTheme.fontFamily,
      scaffoldBackgroundColor: AppColors.offWhite,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.forestGreen,
        primary: AppColors.forestGreen,
        secondary: AppColors.sageGreen,
        surface: AppColors.offWhite,
        error: AppColors.errorRed,
      ),
      textTheme: AppTextTheme.lightTextTheme,
      appBarTheme: AppWidgetTheme.appBarTheme,
      elevatedButtonTheme: AppWidgetTheme.elevatedButtonTheme,
      outlinedButtonTheme: AppWidgetTheme.outlinedButtonTheme,
      inputDecorationTheme: AppWidgetTheme.inputDecorationTheme,
      switchTheme: AppWidgetTheme.switchTheme,
      dividerTheme: AppWidgetTheme.dividerTheme,
      extensions: [TeduhThemeExtension.light],
    );
  }
}
