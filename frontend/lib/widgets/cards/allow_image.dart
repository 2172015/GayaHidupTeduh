/// Mixin dan konfigurasi penempatan gambar pada komponen kartu Gaya Hidup Teduh.
library;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Posisi tata letak gambar saat menggunakan mode [CardImageLayer.inline].
enum CardImagePosition {
  /// Gambar berada di sisi kiri konten utama.
  left,

  /// Gambar berada di sisi kanan konten utama.
  right,

  /// Gambar berada di atas konten utama, rata kiri.
  topLeft,

  /// Gambar berada di atas konten utama, rata tengah.
  topCenter,

  /// Gambar berada di atas konten utama, rata kanan.
  topRight,

  /// Gambar berada di bawah konten utama, rata kiri.
  bottomLeft,

  /// Gambar berada di bawah konten utama, rata tengah.
  bottomCenter,

  /// Gambar berada di bawah konten utama, rata kanan.
  bottomRight,
}

/// Urutan tumpukan (*z-index*) gambar terhadap teks dan isi kartu.
enum CardImageLayer {
  /// Gambar sejajar di dalam susunan tata letak (*Row* / *Column*) bersama teks.
  inline,

  /// Gambar berada di belakang teks sebagai aksen atau *watermark* latar.
  behind,

  /// Gambar berada di atas lapisan teks (*overlay* non-interaktif).
  inFront,
}

/// Konfigurasi gambar yang dapat disematkan ke kartu melalui mixin [AllowImage].
class CardImage {
  /// Path aset gambar lokal (contoh: `'assets/images/homepage/counselor1.png'`).
  final String? assetPath;

  /// Widget gambar kustom jika tidak memakai [assetPath] (misal `Transform.scale` atau `Icon`).
  final Widget? customWidget;

  /// Lebar gambar dalam piksel logis.
  final double width;

  /// Tinggi gambar dalam piksel logis.
  final double height;

  /// Cara penyesuaian gambar di dalam kotaknya.
  final BoxFit fit;

  /// Posisi urutan gambar saat [layer] bernilai [CardImageLayer.inline].
  final CardImagePosition position;

  /// Urutan lapisan (*z-index*) gambar terhadap konten teks kartu.
  final CardImageLayer layer;

  /// Penyelarasan posisi saat [layer] bernilai [CardImageLayer.behind] atau [CardImageLayer.inFront].
  final AlignmentGeometry alignment;

  /// Tingkat transparansi gambar (berguna saat [layer] bernilai [CardImageLayer.behind]).
  final double opacity;

  /// Jarak antara gambar dan konten teks pada mode [CardImageLayer.inline].
  final double spacing;

  /// Jarak tepi gambar saat menggunakan mode [CardImageLayer.behind] atau [CardImageLayer.inFront].
  final EdgeInsetsGeometry padding;

  const CardImage({
    this.assetPath,
    this.customWidget,
    this.width = 64,
    this.height = 64,
    this.fit = BoxFit.contain,
    this.position = CardImagePosition.right,
    this.layer = CardImageLayer.inline,
    this.alignment = Alignment.center,
    this.opacity = 1.0,
    this.spacing = 14,
    this.padding = EdgeInsets.zero,
  }) : assert(
         assetPath != null || customWidget != null,
         'CardImage memerlukan assetPath atau customWidget.',
       );
}

/// Mixin yang memberikan kemampuan rendering gambar terstandar pada kartu.
///
/// Dapat digunakan oleh [DefaultCard] maupun widget kartu kustom lainnya.
mixin AllowImage {
  /// Konfigurasi gambar untuk kartu ini. Jika `null`, kartu dirender tanpa gambar.
  CardImage? get cardImage;

  /// Membangun widget gambar mentah dengan perlindungan *fallback* jika aset gagal dimuat.
  Widget buildRawCardImage(CardImage config) {
    Widget visual;
    if (config.customWidget != null) {
      visual = SizedBox(
        width: config.width,
        height: config.height,
        child: config.customWidget,
      );
    } else {
      visual = Image.asset(
        config.assetPath!,
        width: config.width,
        height: config.height,
        fit: config.fit,
        errorBuilder: (_, _, _) => Container(
          width: config.width,
          height: config.height,
          decoration: BoxDecoration(
            color: AppColors.sageGreen.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.image_outlined,
            color: AppColors.forestGreen,
            size: 28,
          ),
        ),
      );
    }

    if (config.opacity < 1.0) {
      return Opacity(opacity: config.opacity.clamp(0.0, 1.0), child: visual);
    }
    return visual;
  }

  /// Menyusun konten utama kartu bersama gambar bila mode [CardImageLayer.inline] aktif.
  Widget composeInlineImage({required Widget content}) {
    final config = cardImage;
    if (config == null || config.layer != CardImageLayer.inline) {
      return content;
    }

    final imageWidget = buildRawCardImage(config);

    switch (config.position) {
      case CardImagePosition.left:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            imageWidget,
            SizedBox(width: config.spacing),
            Expanded(child: content),
          ],
        );
      case CardImagePosition.right:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: content),
            SizedBox(width: config.spacing),
            imageWidget,
          ],
        );
      case CardImagePosition.topLeft:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(alignment: Alignment.centerLeft, child: imageWidget),
            SizedBox(height: config.spacing),
            content,
          ],
        );
      case CardImagePosition.topCenter:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(alignment: Alignment.center, child: imageWidget),
            SizedBox(height: config.spacing),
            content,
          ],
        );
      case CardImagePosition.topRight:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(alignment: Alignment.centerRight, child: imageWidget),
            SizedBox(height: config.spacing),
            content,
          ],
        );
      case CardImagePosition.bottomLeft:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            content,
            SizedBox(height: config.spacing),
            Align(alignment: Alignment.centerLeft, child: imageWidget),
          ],
        );
      case CardImagePosition.bottomCenter:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            content,
            SizedBox(height: config.spacing),
            Align(alignment: Alignment.center, child: imageWidget),
          ],
        );
      case CardImagePosition.bottomRight:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            content,
            SizedBox(height: config.spacing),
            Align(alignment: Alignment.centerRight, child: imageWidget),
          ],
        );
    }
  }

  /// Membungkus konten kartu dengan gambar berlapis (*z-index*) jika menggunakan
  /// [CardImageLayer.behind] atau [CardImageLayer.inFront].
  Widget wrapWithLayeredImage({required Widget content}) {
    final config = cardImage;
    if (config == null || config.layer == CardImageLayer.inline) {
      return content;
    }

    final layeredImage = Positioned.fill(
      child: IgnorePointer(
        child: Padding(
          padding: config.padding,
          child: Align(
            alignment: config.alignment,
            child: buildRawCardImage(config),
          ),
        ),
      ),
    );

    return Stack(
      children: config.layer == CardImageLayer.behind
          ? [layeredImage, content]
          : [content, layeredImage],
    );
  }
}
