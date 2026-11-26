import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_theme.dart';

/// Kumpulan konfigurasi tema default untuk widget bawaan Flutter
/// seperti [AppBar], [ElevatedButton], [OutlinedButton], [TextField], dan [Switch].
class AppWidgetTheme {
  AppWidgetTheme._();

  /// Tema [AppBar] transparan dengan judul rata tengah berwarna [AppColors.forestGreen].
  static AppBarTheme get appBarTheme {
    return const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      foregroundColor: AppColors.forestGreen,
      iconTheme: IconThemeData(color: AppColors.forestGreen, size: 20),
      titleTextStyle: TextStyle(
        fontFamily: AppTextTheme.fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.forestGreen,
      ),
    );
  }

  /// Tema tombol utama berbentuk *pill* dengan latar [AppColors.sageGreen].
  static ElevatedButtonThemeData get elevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.sageGreen,
        foregroundColor: AppColors.forestGreen,
        elevation: 0,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: const TextStyle(
          fontFamily: AppTextTheme.fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  /// Tema tombol sekunder berbingkai [AppColors.forestGreen] dengan latar putih.
  static OutlinedButtonThemeData get outlinedButtonTheme {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.pureWhite,
        foregroundColor: AppColors.forestGreen,
        side: const BorderSide(color: AppColors.forestGreen, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        textStyle: const TextStyle(
          fontFamily: AppTextTheme.fontFamily,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  /// Tema kolom input teks standar berbentuk *pill* dengan validasi [AppColors.errorRed].
  static InputDecorationTheme get inputDecorationTheme {
    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.pureWhite,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      hintStyle: TextStyle(
        color: AppColors.forestGreen.withValues(alpha: 0.45),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: AppColors.lightGray, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: AppColors.forestGreen, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: AppColors.errorRed, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: AppColors.errorRed, width: 1.6),
      ),
    );
  }

  /// Tema tombol *toggle* [Switch] dengan warna aktif [AppColors.forestGreen].
  static SwitchThemeData get switchTheme {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.pureWhite;
        }
        return AppColors.forestGreen.withValues(alpha: 0.6);
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.forestGreen;
        }
        return AppColors.lightGray;
      }),
    );
  }

  /// Tema garis pemisah horizontal tipis bernuansa [AppColors.forestGreen].
  static DividerThemeData get dividerTheme {
    return DividerThemeData(
      color: AppColors.forestGreen.withValues(alpha: 0.18),
      thickness: 1,
      space: 1,
    );
  }
}
