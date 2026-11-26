import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Konfigurasi tipografi terpusat menggunakan font **Poppins**.
///
/// Hierarki warna default:
/// - **Judul layar, judul section, & judul kartu:** [AppColors.forestGreen]
/// - **Isi bacaan & subjudul kartu:** [AppColors.bodyText]
class AppTextTheme {
  AppTextTheme._();

  /// Nama keluarga font utama yang terdaftar di `pubspec.yaml`.
  static const String fontFamily = 'Poppins';

  /// Skema [TextTheme] standar untuk [ThemeData.textTheme] pada mode terang.
  static TextTheme get lightTextTheme {
    return const TextTheme(
      /// Judul besar pada halaman tab utama (*Home, Diary, Counseling, Profile*).
      displaySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.forestGreen,
      ),

      /// Heading utama layar atau penanda urutan seperti `"Day #1"`.
      headlineMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.forestGreen,
      ),

      /// Judul tengah pada [AppBar] dan judul bagian (*Section Header*).
      titleLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.forestGreen,
      ),

      /// Judul default di dalam kartu ([AppColors.forestGreen]).
      titleMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.forestGreen,
      ),

      /// Subjudul pengantar di bawah judul utama layar.
      titleSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.forestGreen,
      ),

      /// Teks isi dengan penekanan (*SemiBold*) menggunakan [AppColors.bodyText].
      bodyLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.bodyText,
      ),

      /// Teks paragraf utama untuk isi diary, catatan konselor, dan pesan mailbox.
      bodyMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: AppColors.bodyText,
      ),

      /// Subjudul default di dalam kartu dan teks keterangan ringkas.
      bodySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12.5,
        fontWeight: FontWeight.w400,
        height: 1.35,
        color: AppColors.bodyText,
      ),

      /// Gaya teks default untuk tombol aksi utama.
      labelLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.forestGreen,
      ),
    );
  }

  /// Teks identitas `"Gaya Hidup Teduh"` di pojok kiri atas halaman tab utama.
  static const TextStyle brandEyebrow = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.mutedText,
  );

  /// Mengembalikan gaya judul kartu dengan default [AppColors.forestGreen]
  /// yang dapat di-override melalui parameter [color] atau [fontSize].
  static TextStyle cardTitle({Color? color, double fontSize = 16}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      color: color ?? AppColors.forestGreen,
    );
  }

  /// Mengembalikan gaya subjudul kartu dengan default [AppColors.bodyText]
  /// yang dapat di-override melalui parameter [color] atau [fontSize].
  static TextStyle cardSubtitle({Color? color, double fontSize = 12.5}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      height: 1.35,
      color: color ?? AppColors.bodyText,
    );
  }
}
