import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/diary_aspect.dart';

class DiaryAspectCard extends StatelessWidget {
  final DiaryAspect aspect;
  final TextEditingController? controller;
  final String? readOnlyText;
  final bool isReadOnly;

  const DiaryAspectCard({
    super.key,
    required this.aspect,
    this.controller,
    this.readOnlyText,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasReadText = readOnlyText != null && readOnlyText!.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.forestGreen.withValues(alpha: 0.25),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul Bernomor: "1. Me & My God"
          Text(
            aspect.numberedTitle,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E1E1E),
            ),
          ),
          const SizedBox(height: 4),

          // Pertanyaan Pemandu
          Text(
            aspect.question,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              height: 1.35,
              color: Color(0xFF1E1E1E),
            ),
          ),
          const SizedBox(height: 12),

          // Kotak Isi Refleksi (Abu-abu lembut sesuai mockup)
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 150),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFE6E6E6),
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
                          ? const Color(0xFF383329)
                          : const Color(0xFF383329).withValues(alpha: 0.5),
                    ),
                  )
                : TextField(
                    controller: controller,
                    maxLines: null,
                    minLines: 6,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    style: const TextStyle(
                      fontSize: 13.5,
                      height: 1.5,
                      color: Color(0xFF383329),
                    ),
                    decoration: InputDecoration(
                      hintText: aspect.placeholder,
                      hintMaxLines: 8,
                      hintStyle: TextStyle(
                        fontSize: 12.5,
                        height: 1.45,
                        color: const Color(0xFF383329).withValues(alpha: 0.55),
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
      ),
    );
  }
}
