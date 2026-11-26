import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../models/mood_level.dart';

class MoodLevelIndicator extends StatelessWidget {
  final double averageScore;

  const MoodLevelIndicator({super.key, required this.averageScore});

  @override
  Widget build(BuildContext context) {
    final activeLevel = MoodLevel.fromScore(averageScore.round());

    return Column(
      children: [
        Row(
          children: MoodLevel.values.map((level) {
            final isSelected = level == activeLevel;
            final fgColor = (isSelected && level.useLightForeground)
                ? AppColors.pureWhite
                : const Color(0xFF1E1E1E);

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: level == MoodLevel.veryHigh ? 0 : 8,
                ),
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      height: 36,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? level.activeColor
                            : const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.12),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: CustomPaint(
                        size: const Size(24, 18),
                        painter: _MoodFacePainter(level: level, color: fgColor),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      level.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: AppColors.forestGreen,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        const Text(
          'Mood Level',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.forestGreen,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Rata-rata Keseimbangan: ${averageScore.toStringAsFixed(1)} / 10',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.forestGreen.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

class _MoodFacePainter extends CustomPainter {
  final MoodLevel level;
  final Color color;

  const _MoodFacePainter({required this.level, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final eyePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    final leftEye = Offset(size.width * 0.34, size.height * 0.35);
    final rightEye = Offset(size.width * 0.66, size.height * 0.35);

    if (level == MoodLevel.high) {
      canvas.drawLine(
        leftEye.translate(-2.5, -2),
        leftEye.translate(1.5, 0),
        strokePaint,
      );
      canvas.drawLine(
        leftEye.translate(-2.5, 2),
        leftEye.translate(1.5, 0),
        strokePaint,
      );
      canvas.drawLine(
        rightEye.translate(2.5, -2),
        rightEye.translate(-1.5, 0),
        strokePaint,
      );
      canvas.drawLine(
        rightEye.translate(2.5, 2),
        rightEye.translate(-1.5, 0),
        strokePaint,
      );
    } else {
      canvas.drawCircle(leftEye, 1.7, eyePaint);
      canvas.drawCircle(rightEye, 1.7, eyePaint);
    }

    final mouthPath = Path();
    switch (level) {
      case MoodLevel.veryLow:
        mouthPath.moveTo(size.width * 0.34, size.height * 0.74);
        mouthPath.lineTo(size.width * 0.66, size.height * 0.74);
        break;
      case MoodLevel.low:
        mouthPath.moveTo(size.width * 0.34, size.height * 0.76);
        mouthPath.quadraticBezierTo(
          size.width * 0.5,
          size.height * 0.60,
          size.width * 0.66,
          size.height * 0.76,
        );
        break;
      case MoodLevel.balance:
        mouthPath.moveTo(size.width * 0.35, size.height * 0.72);
        mouthPath.lineTo(size.width * 0.65, size.height * 0.72);
        break;
      case MoodLevel.high:
        mouthPath.moveTo(size.width * 0.36, size.height * 0.66);
        mouthPath.quadraticBezierTo(
          size.width * 0.5,
          size.height * 0.82,
          size.width * 0.64,
          size.height * 0.66,
        );
        break;
      case MoodLevel.veryHigh:
        mouthPath.moveTo(size.width * 0.33, size.height * 0.62);
        mouthPath.quadraticBezierTo(
          size.width * 0.5,
          size.height * 0.88,
          size.width * 0.67,
          size.height * 0.62,
        );
        break;
    }
    canvas.drawPath(mouthPath, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _MoodFacePainter oldDelegate) {
    return oldDelegate.level != level || oldDelegate.color != color;
  }
}
