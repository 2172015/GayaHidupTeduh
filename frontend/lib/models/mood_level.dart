import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

enum MoodLevel {
  veryLow(
    label: 'Very Low',
    activeColor: Color(0xFF8C3B2B),
    useLightForeground: true,
  ),
  low(label: 'Low', activeColor: Color(0xFFE07A5F), useLightForeground: false),
  balance(
    label: 'Balance',
    activeColor: Color(0xFFE9D8A6),
    useLightForeground: false,
  ),
  high(
    label: 'High',
    activeColor: AppColors.sageGreen,
    useLightForeground: false,
  ),
  veryHigh(
    label: 'Very High',
    activeColor: AppColors.forestGreen,
    useLightForeground: true,
  );

  final String label;
  final Color activeColor;
  final bool useLightForeground;

  const MoodLevel({
    required this.label,
    required this.activeColor,
    required this.useLightForeground,
  });

  static MoodLevel fromScore(int score) {
    if (score <= 2) return MoodLevel.veryLow;
    if (score <= 4) return MoodLevel.low;
    if (score <= 6) return MoodLevel.balance;
    if (score <= 8) return MoodLevel.high;
    return MoodLevel.veryHigh;
  }
}
