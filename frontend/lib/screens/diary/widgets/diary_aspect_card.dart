/// Kartu aspek refleksi diary yang mewarisi [DefaultCard].
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_theme.dart';
import '../../../models/diary_aspect.dart';
import '../../../widgets/cards/default_card.dart';

/// Kartu untuk menampilkan pertanyaan satu [DiaryAspect] beserta kotak
/// refleksinya pada [DiaryFormScreen] (`isReadOnly: false`) maupun
/// [DiaryDetailScreen] (`isReadOnly: true`).
class DiaryAspectCard extends DefaultCard {
  /// Nomor urut aspek yang ditampilkan di depan judul (contoh: `1`, `2`, `3`).
  final int aspectNumber;

  /// Metadata aspek ([DiaryAspect]) yang ditampilkan.
  final DiaryAspect aspect;

  /// Controller teks untuk mode penyuntingan (`isReadOnly: false`).
  final TextEditingController? controller;

  /// Teks refleksi tersimpan untuk mode baca (`isReadOnly: true`).
  final String? readOnlyText;

  /// Menentukan apakah kartu berada dalam mode baca saja (`true`) atau input (`false`).
  final bool isReadOnly;

  /// Override batas maksimal karakter (default mengikuti [DiaryAspect.maxChar]).
  final int? maxChar;

  /// Warna latar lembut untuk kotak area penulisan refleksi.
  static const Color _reflectionBoxColor = Color(0xFFE6E6E6);

  const DiaryAspectCard({
    super.key,
    required this.aspectNumber,
    required this.aspect,
    this.controller,
    this.readOnlyText,
    this.isReadOnly = false,
    this.maxChar,
    super.isActive,
    super.isEnabled,
  }) : super(borderRadius: 18, padding: const EdgeInsets.all(16));

  @override
  Widget buildCardBody(BuildContext context) {
    final hasReadText = readOnlyText != null && readOnlyText!.trim().isNotEmpty;
    final effectiveMaxChar = maxChar ?? aspect.maxChar;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Judul Bernomor: "1. Me & My God"
        Text(
          '$aspectNumber. ${aspect.title}',
          style: AppTextTheme.cardTitle(fontSize: 16.5),
        ),
        const SizedBox(height: 4),

        // Pertanyaan Pemandu
        Text(
          aspect.question,
          style: AppTextTheme.cardSubtitle(
            fontSize: 13.5,
            color: AppColors.bodyText,
          ),
        ),
        const SizedBox(height: 12),

        // Kotak Isi Refleksi
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 150),
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
          decoration: BoxDecoration(
            color: _reflectionBoxColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.forestGreen.withValues(alpha: 0.2),
            ),
          ),
          child: isReadOnly
              ? Text(
                  hasReadText
                      ? readOnlyText!
                      : 'Belum ada cerita yang dituliskan untuk aspek ini.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    fontStyle: hasReadText
                        ? FontStyle.normal
                        : FontStyle.italic,
                    color: hasReadText
                        ? AppColors.bodyText
                        : AppColors.bodyText.withValues(alpha: 0.55),
                  ),
                )
              : TextField(
                  controller: controller,
                  enabled: isEnabled,
                  maxLines: null,
                  minLines: 5,
                  maxLength: effectiveMaxChar,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  style: const TextStyle(
                    fontSize: 13.5,
                    height: 1.5,
                    color: AppColors.bodyText,
                  ),
                  buildCounter:
                      (
                        context, {
                        required currentLength,
                        required isFocused,
                        required maxLength,
                      }) {
                        final limit = maxLength ?? effectiveMaxChar;
                        final isNearLimit = currentLength >= (limit * 0.9);
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '$currentLength/$limit',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isNearLimit
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isNearLimit
                                    ? AppColors.errorRed
                                    : AppColors.mutedText,
                              ),
                            ),
                          ),
                        );
                      },
                  decoration: InputDecoration(
                    hintText: aspect.description,
                    hintMaxLines: 8,
                    hintStyle: TextStyle(
                      fontSize: 12.5,
                      height: 1.45,
                      color: AppColors.bodyText.withValues(alpha: 0.55),
                    ),
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
        ),
      ],
    );
  }
}
