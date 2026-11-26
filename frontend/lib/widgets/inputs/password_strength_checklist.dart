import 'package:flutter/material.dart';

import '../../core/app_colors.dart';

class PasswordStrengthChecklist extends StatelessWidget {
  final TextEditingController passwordController;

  const PasswordStrengthChecklist({
    super.key,
    required this.passwordController,
  });

  Widget _buildItem(String label, bool isValid) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isValid ? Icons.check_circle_rounded : Icons.circle_outlined,
          size: 14,
          color: isValid
              ? AppColors.lightForestGreen
              : AppColors.forestGreen.withValues(alpha: 0.4),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            color: isValid
                ? AppColors.forestGreen
                : AppColors.forestGreen.withValues(alpha: 0.55),
            fontWeight: isValid ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: passwordController,
      builder: (context, value, _) {
        final text = value.text;
        if (text.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 12,
              runSpacing: 4,
              children: [
                _buildItem('8+ karakter', text.length >= 8),
                _buildItem('1 Huruf Kapital', RegExp(r'[A-Z]').hasMatch(text)),
                _buildItem('1 Angka', RegExp(r'[0-9]').hasMatch(text)),
                _buildItem(
                  '1 Simbol',
                  RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-]').hasMatch(text),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
