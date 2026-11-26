import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class MoodScoreSlider extends StatelessWidget {
  final int value;
  final String emotionLabel;
  final ValueChanged<int> onChanged;

  const MoodScoreSlider({
    super.key,
    required this.value,
    required this.emotionLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 11,
            activeTrackColor: AppColors.sageGreen,
            inactiveTrackColor: AppColors.pureWhite,
            overlayColor: AppColors.sageGreen.withValues(alpha: 0.2),
            tickMarkShape: SliderTickMarkShape.noTickMark,
            thumbShape: _NumberedCircleThumbShape(
              thumbRadius: 23,
              value: value,
            ),
          ),
          child: Slider(
            value: value.toDouble(),
            min: 0,
            max: 10,
            divisions: 10,
            onChanged: (raw) => onChanged(raw.round()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '0',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppColors.forestGreen,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  emotionLabel,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.forestGreen,
                  ),
                ),
              ),
              const Text(
                '10',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppColors.forestGreen,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NumberedCircleThumbShape extends SliderComponentShape {
  final double thumbRadius;
  final int value;

  const _NumberedCircleThumbShape({
    required this.thumbRadius,
    required this.value,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.16)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(center.translate(0, 2), thumbRadius, shadowPaint);

    final fillPaint = Paint()
      ..color = const Color(0xFF9AB87A)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, thumbRadius, fillPaint);

    final borderPaint = Paint()
      ..color = AppColors.forestGreen.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawCircle(center, thumbRadius, borderPaint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: '${this.value}',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.forestGreen,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      center - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }
}
