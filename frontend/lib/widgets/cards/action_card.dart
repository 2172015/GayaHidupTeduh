/// Turunan [DefaultCard] yang menyertakan tombol aksi [ElevatedButton].
library;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'default_card.dart';

/// Kartu yang mewarisi seluruh kemampuan [DefaultCard] dan menambahkan
/// tombol aksi [ElevatedButton] di bagian bawah konten.
class ActionCard extends DefaultCard {
  /// Teks label yang ditampilkan pada tombol.
  final String buttonLabel;

  /// Aksi saat tombol ditekan (otomatis nonaktif jika [isEnabled] bernilai `false`).
  final VoidCallback? onButtonPressed;

  /// Jika `true`, tombol melebar penuh mengikuti lebar kartu.
  /// Jika `false`, lebar tombol menyesuaikan panjang [buttonLabel].
  final bool isButtonExpanded;

  /// Penyelarasan posisi tombol saat [isButtonExpanded] bernilai `false`.
  final AlignmentGeometry buttonAlignment;

  /// Warna latar belakang tombol (default mengikuti tema [ElevatedButton]).
  final Color? buttonBackgroundColor;

  /// Warna teks dan ikon pada tombol.
  final Color? buttonForegroundColor;

  /// Ikon opsional di sisi kiri [buttonLabel].
  final IconData? buttonIcon;

  const ActionCard({
    super.key,
    required this.buttonLabel,
    this.onButtonPressed,
    this.isButtonExpanded = true,
    this.buttonAlignment = Alignment.centerRight,
    this.buttonBackgroundColor,
    this.buttonForegroundColor,
    this.buttonIcon,
    super.isActive,
    super.isEnabled,
    super.title,
    super.subtitle,
    super.body,
    super.titleStyle,
    super.subtitleStyle,
    super.bodyStyle,
    super.titleColor,
    super.subtitleColor,
    super.bodyColor,
    super.titleMaxLines,
    super.subtitleMaxLines,
    super.bodyMaxLines,
    super.leading,
    super.trailing,
    super.child,
    super.cardImage,
    super.backgroundColor,
    super.hasBorder,
    super.border,
    super.hasShadow,
    super.boxShadow,
    super.borderRadius,
    super.padding,
    super.margin,
    super.onTap,
  });

  @override
  Widget buildCardBody(BuildContext context) {
    final baseBody = super.buildCardBody(context);
    final effectiveButtonTap = isEnabled ? onButtonPressed : null;

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: buttonBackgroundColor ?? AppColors.sageGreen,
      foregroundColor: buttonForegroundColor ?? AppColors.forestGreen,
      minimumSize: Size(isButtonExpanded ? double.infinity : 110, 44),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    );

    final Widget buttonWidget = buttonIcon != null
        ? ElevatedButton.icon(
            onPressed: effectiveButtonTap,
            style: buttonStyle,
            icon: Icon(buttonIcon, size: 18),
            label: Text(buttonLabel),
          )
        : ElevatedButton(
            onPressed: effectiveButtonTap,
            style: buttonStyle,
            child: Text(buttonLabel),
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        baseBody,
        const SizedBox(height: 14),
        isButtonExpanded
            ? buttonWidget
            : Align(alignment: buttonAlignment, child: buttonWidget),
      ],
    );
  }
}
