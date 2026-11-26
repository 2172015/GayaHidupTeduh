/// Komponen kartu dasar standar untuk seluruh antarmuka Gaya Hidup Teduh.
library;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_theme.dart';
import '../../core/theme/teduh_theme_extension.dart';
import 'allow_image.dart';

/// Kartu dasar yang mengintegrasikan gaya dari [TeduhThemeExtension] dan [AppTextTheme].
///
/// Mendukung:
/// - **Visibilitas & Interaksi:** [isActive] (*show/hide*) dan [isEnabled] (*clickable/disabled*).
/// - **Dekorasi Tema:** [hasBorder] dan [hasShadow] aktif secara default dan dapat di-override.
/// - **Konten Premade maupun Kustom:** Dapat menampilkan [title], [subtitle], [body],
///   [leading], [trailing], atau widget bebas melalui [child].
/// - **Dukungan Gambar:** Menggunakan mixin [AllowImage] melalui parameter [cardImage].
class DefaultCard extends StatelessWidget with AllowImage {
  /// Menentukan apakah kartu ditampilkan (`true`) atau disembunyikan (`false`).
  final bool isActive;

  /// Menentukan apakah kartu dapat diklik (`true`) atau dalam keadaan nonaktif (`false`).
  final bool isEnabled;

  /// Judul utama kartu (default menggunakan [AppColors.forestGreen]).
  final String? title;

  /// Subjudul ringkas di bawah [title] (default menggunakan [AppColors.bodyText]).
  final String? subtitle;

  /// Paragraf isi tambahan di bawah [subtitle] (default menggunakan [AppColors.bodyText]).
  final String? body;

  /// Override gaya teks lengkap untuk [title].
  final TextStyle? titleStyle;

  /// Override gaya teks lengkap untuk [subtitle].
  final TextStyle? subtitleStyle;

  /// Override gaya teks lengkap untuk [body].
  final TextStyle? bodyStyle;

  /// Override warna khusus untuk [title] tanpa mengganti ukuran/bobot font.
  final Color? titleColor;

  /// Override warna khusus untuk [subtitle] tanpa mengganti ukuran/bobot font.
  final Color? subtitleColor;

  /// Override warna khusus untuk [body] tanpa mengganti ukuran/bobot font.
  final Color? bodyColor;

  /// Batas maksimal baris untuk [title].
  final int? titleMaxLines;

  /// Batas maksimal baris untuk [subtitle].
  final int? subtitleMaxLines;

  /// Batas maksimal baris untuk [body].
  final int? bodyMaxLines;

  /// Widget pendamping di sisi kiri teks (misalnya ikon atau avatar).
  final Widget? leading;

  /// Widget pendamping di sisi kanan teks (misalnya chevron `>` atau *badge* status).
  final Widget? trailing;

  /// Konten kustom bebas di dalam kartu (seperti slider, grafik, atau daftar rincian).
  final Widget? child;

  /// Konfigurasi gambar opsional yang dirender oleh mixin [AllowImage].
  @override
  final CardImage? cardImage;

  /// Override warna latar belakang kartu (default mengikuti [TeduhThemeExtension.defaultCardColor]).
  final Color? backgroundColor;

  /// Menampilkan garis tepi kartu secara default (`true`).
  final bool hasBorder;

  /// Override garis tepi kustom (misalnya garis putus-putus untuk *Draft*).
  final BoxBorder? border;

  /// Menampilkan efek bayangan lembut secara default (`true`).
  final bool hasShadow;

  /// Override bayangan kustom untuk kartu.
  final List<BoxShadow>? boxShadow;

  /// Override radius sudut kartu (default mengikuti [TeduhThemeExtension.defaultCardRadius]).
  final double? borderRadius;

  /// Override jarak dalam (*padding*) kartu (default mengikuti [TeduhThemeExtension.defaultCardPadding]).
  final EdgeInsetsGeometry? padding;

  /// Jarak luar (*margin*) di sekeliling kartu.
  final EdgeInsetsGeometry? margin;

  /// Aksi ketika kartu diketuk (otomatis nonaktif jika [isEnabled] bernilai `false`).
  final VoidCallback? onTap;

  const DefaultCard({
    super.key,
    this.isActive = true,
    this.isEnabled = true,
    this.title,
    this.subtitle,
    this.body,
    this.titleStyle,
    this.subtitleStyle,
    this.bodyStyle,
    this.titleColor,
    this.subtitleColor,
    this.bodyColor,
    this.titleMaxLines,
    this.subtitleMaxLines,
    this.bodyMaxLines,
    this.leading,
    this.trailing,
    this.child,
    this.cardImage,
    this.backgroundColor,
    this.hasBorder = true,
    this.border,
    this.hasShadow = true,
    this.boxShadow,
    this.borderRadius,
    this.padding,
    this.margin,
    this.onTap,
  });

  /// Mengembalikan `true` jika kartu memiliki teks premade ([title], [subtitle], atau [body]).
  bool get hasHeaderText => title != null || subtitle != null || body != null;

  /// Membangun susunan konten bagian dalam kartu sebelum dibungkus dekorasi wadah.
  Widget buildCardBody(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final resolvedTitleStyle =
        titleStyle ??
        (textTheme.titleMedium ?? AppTextTheme.cardTitle()).copyWith(
          color: titleColor,
        );

    final resolvedSubtitleStyle =
        subtitleStyle ??
        (textTheme.bodySmall ?? AppTextTheme.cardSubtitle()).copyWith(
          color: subtitleColor,
        );

    final resolvedBodyStyle =
        bodyStyle ??
        (textTheme.bodyMedium ??
                const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: AppColors.bodyText,
                ))
            .copyWith(color: bodyColor);

    final Widget? headerColumn = hasHeaderText
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null)
                Text(
                  title!,
                  maxLines: titleMaxLines,
                  overflow: titleMaxLines != null
                      ? TextOverflow.ellipsis
                      : null,
                  style: resolvedTitleStyle,
                ),
              if (subtitle != null) ...[
                if (title != null) const SizedBox(height: 4),
                Text(
                  subtitle!,
                  maxLines: subtitleMaxLines,
                  overflow: subtitleMaxLines != null
                      ? TextOverflow.ellipsis
                      : null,
                  style: resolvedSubtitleStyle,
                ),
              ],
              if (body != null) ...[
                if (title != null || subtitle != null)
                  const SizedBox(height: 6),
                Text(
                  body!,
                  maxLines: bodyMaxLines,
                  overflow: bodyMaxLines != null ? TextOverflow.ellipsis : null,
                  style: resolvedBodyStyle,
                ),
              ],
            ],
          )
        : null;

    Widget? mainContent;
    if (headerColumn != null && child != null) {
      mainContent = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [headerColumn, const SizedBox(height: 12), child!],
      );
    } else {
      mainContent = headerColumn ?? child;
    }

    if (leading != null || trailing != null) {
      mainContent = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 14)],
          if (mainContent != null) Expanded(child: mainContent),
          if (trailing != null) ...[const SizedBox(width: 12), trailing!],
        ],
      );
    }

    return composeInlineImage(content: mainContent ?? const SizedBox.shrink());
  }

  @override
  Widget build(BuildContext context) {
    if (!isActive) return const SizedBox.shrink();

    final teduhTheme = TeduhThemeExtension.of(context);
    final resolvedRadius = borderRadius ?? teduhTheme.defaultCardRadius;
    final resolvedBackground = backgroundColor ?? teduhTheme.defaultCardColor;
    final resolvedPadding = padding ?? teduhTheme.defaultCardPadding;
    final resolvedBorder =
        border ?? (hasBorder ? teduhTheme.defaultCardBorder : null);
    final resolvedShadow =
        boxShadow ?? (hasShadow ? teduhTheme.defaultCardShadow : null);
    final effectiveOnTap = isEnabled ? onTap : null;

    Widget cardContent = Padding(
      padding: resolvedPadding,
      child: buildCardBody(context),
    );

    cardContent = wrapWithLayeredImage(content: cardContent);

    if (effectiveOnTap != null) {
      cardContent = Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(resolvedRadius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: effectiveOnTap,
          splashColor: AppColors.sageGreen.withValues(alpha: 0.2),
          highlightColor: AppColors.sageGreen.withValues(alpha: 0.1),
          child: cardContent,
        ),
      );
    }

    Widget cardContainer = Container(
      width: double.infinity,
      margin: margin,
      decoration: BoxDecoration(
        color: resolvedBackground,
        borderRadius: BorderRadius.circular(resolvedRadius),
        border: resolvedBorder,
        boxShadow: resolvedShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(resolvedRadius),
        child: cardContent,
      ),
    );

    if (!isEnabled) {
      cardContainer = Opacity(
        opacity: teduhTheme.defaultCardDisabledOpacity,
        child: cardContainer,
      );
    }

    return cardContainer;
  }
}
