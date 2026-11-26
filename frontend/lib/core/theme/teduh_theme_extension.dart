/// Ekstensi tema khusus Gaya Hidup Teduh untuk properti visual layar dan kartu.
library;

import 'dart:ui';

import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Ekstensi tema khusus **Gaya Hidup Teduh** untuk menyimpan properti visual
/// yang tidak tersedia di [ThemeData] bawaan Flutter, seperti gradasi layar
/// dan gaya standar untuk [DefaultCard].
///
/// Akses melalui `TeduhThemeExtension.of(context)`.
class TeduhThemeExtension extends ThemeExtension<TeduhThemeExtension> {
  /// Warna latar polos (*flat*) saat layar tidak menggunakan gradasi.
  final Color flatBackgroundColor;

  /// Gradasi vertikal utama layar dari [AppColors.offWhite] ke [AppColors.gradientSage].
  final Gradient backgroundGradient;

  /// Warna latar permukaan default untuk kartu.
  final Color defaultCardColor;

  /// Garis tepi (*border*) default untuk kartu.
  final Border defaultCardBorder;

  /// Radius sudut membulat default untuk kartu.
  final double defaultCardRadius;

  /// Efek bayangan lembut (*soft drop shadow*) default untuk kartu.
  final List<BoxShadow> defaultCardShadow;

  /// Jarak dalam (*padding*) default untuk isi kartu.
  final EdgeInsetsGeometry defaultCardPadding;

  /// Tingkat opasitas kartu saat properti `isEnabled` bernilai `false`.
  final double defaultCardDisabledOpacity;

  const TeduhThemeExtension({
    required this.flatBackgroundColor,
    required this.backgroundGradient,
    required this.defaultCardColor,
    required this.defaultCardBorder,
    required this.defaultCardRadius,
    required this.defaultCardShadow,
    this.defaultCardPadding = const EdgeInsets.symmetric(
      horizontal: 18,
      vertical: 16,
    ),
    this.defaultCardDisabledOpacity = 0.55,
  });

  /// Konfigurasi standar ekstensi tema untuk mode terang (*Light Theme*).
  static TeduhThemeExtension get light {
    return TeduhThemeExtension(
      flatBackgroundColor: AppColors.offWhite,
      backgroundGradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.0, 0.48, 1.0],
        colors: [
          AppColors.offWhite,
          AppColors.offWhite,
          AppColors.gradientSage,
        ],
      ),
      defaultCardColor: AppColors.offWhite,
      defaultCardBorder: Border.all(
        color: AppColors.forestGreen.withValues(alpha: 0.25),
        width: 1.0,
      ),
      defaultCardRadius: 20.0,
      defaultCardShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
      defaultCardPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 16,
      ),
      defaultCardDisabledOpacity: 0.55,
    );
  }

  /// Mengambil instance [TeduhThemeExtension] aktif dari [BuildContext].
  static TeduhThemeExtension of(BuildContext context) {
    return Theme.of(context).extension<TeduhThemeExtension>() ?? light;
  }

  @override
  TeduhThemeExtension copyWith({
    Color? flatBackgroundColor,
    Gradient? backgroundGradient,
    Color? defaultCardColor,
    Border? defaultCardBorder,
    double? defaultCardRadius,
    List<BoxShadow>? defaultCardShadow,
    EdgeInsetsGeometry? defaultCardPadding,
    double? defaultCardDisabledOpacity,
  }) {
    return TeduhThemeExtension(
      flatBackgroundColor: flatBackgroundColor ?? this.flatBackgroundColor,
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
      defaultCardColor: defaultCardColor ?? this.defaultCardColor,
      defaultCardBorder: defaultCardBorder ?? this.defaultCardBorder,
      defaultCardRadius: defaultCardRadius ?? this.defaultCardRadius,
      defaultCardShadow: defaultCardShadow ?? this.defaultCardShadow,
      defaultCardPadding: defaultCardPadding ?? this.defaultCardPadding,
      defaultCardDisabledOpacity:
          defaultCardDisabledOpacity ?? this.defaultCardDisabledOpacity,
    );
  }

  @override
  TeduhThemeExtension lerp(
    covariant ThemeExtension<TeduhThemeExtension>? other,
    double t,
  ) {
    if (other is! TeduhThemeExtension) return this;
    return TeduhThemeExtension(
      flatBackgroundColor:
          Color.lerp(flatBackgroundColor, other.flatBackgroundColor, t) ??
          flatBackgroundColor,
      backgroundGradient:
          Gradient.lerp(backgroundGradient, other.backgroundGradient, t) ??
          backgroundGradient,
      defaultCardColor:
          Color.lerp(defaultCardColor, other.defaultCardColor, t) ??
          defaultCardColor,
      defaultCardBorder: t < 0.5 ? defaultCardBorder : other.defaultCardBorder,
      defaultCardRadius:
          lerpDouble(defaultCardRadius, other.defaultCardRadius, t) ??
          defaultCardRadius,
      defaultCardShadow: t < 0.5 ? defaultCardShadow : other.defaultCardShadow,
      defaultCardPadding:
          EdgeInsetsGeometry.lerp(
            defaultCardPadding,
            other.defaultCardPadding,
            t,
          ) ??
          defaultCardPadding,
      defaultCardDisabledOpacity:
          lerpDouble(
            defaultCardDisabledOpacity,
            other.defaultCardDisabledOpacity,
            t,
          ) ??
          defaultCardDisabledOpacity,
    );
  }
}
