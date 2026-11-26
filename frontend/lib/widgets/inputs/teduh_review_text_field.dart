import 'package:flutter/material.dart';

import '../../core/app_colors.dart';

class TeduhReviewTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final int maxLength;
  final bool enabled;

  const TeduhReviewTextField({
    super.key,
    required this.controller,
    this.hintText = 'Bagikan pengalamanmu selama sesi konseling ini...',
    this.maxLines = 4,
    this.maxLength = 300,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.offWhite.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.forestGreen.withValues(alpha: 0.25),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.forestGreen.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        maxLines: maxLines,
        maxLength: maxLength,
        textCapitalization: TextCapitalization.sentences,
        style: const TextStyle(
          fontSize: 13.5,
          height: 1.5,
          color: Color(0xFF1E1E1E),
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 13,
            color: AppColors.forestGreen.withValues(alpha: 0.45),
          ),
          filled: false,
          contentPadding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
          counterStyle: TextStyle(
            fontSize: 11,
            color: AppColors.forestGreen.withValues(alpha: 0.6),
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
      ),
    );
  }
}
