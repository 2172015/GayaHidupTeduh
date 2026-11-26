import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../models/mail_thread.dart';

class MailThreadCard extends StatelessWidget {
  final MailThread thread;
  final VoidCallback onTap;

  const MailThreadCard({super.key, required this.thread, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bgColor = thread.isDraft
        ? AppColors.offWhite
        : thread.isUnread
        ? AppColors.pureWhite
        : const Color(0xFFEAE5D9);

    final content = Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: thread.isDraft
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.07),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          splashColor: AppColors.sageGreen.withValues(alpha: 0.2),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          thread.subject,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E1E1E),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (thread.isUnread && !thread.isDraft) ...[
                          Container(
                            width: 9,
                            height: 9,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.sageGreen,
                            ),
                          ),
                          const SizedBox(height: 2),
                        ],
                        if (thread.isDraft)
                          const Text(
                            'Draft',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFB38B59),
                            ),
                          ),
                        Text(
                          thread.formattedListTime,
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF4F554B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  thread.previewText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: Color(0xFF383329),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (!thread.isDraft) return content;

    return CustomPaint(
      painter: _DashedRoundedRectPainter(
        color: const Color(0xFF9E9A90),
        radius: 18,
      ),
      child: content,
    );
  }
}

class _DashedRoundedRectPainter extends CustomPainter {
  final Color color;
  final double radius;

  const _DashedRoundedRectPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);

    const dashWidth = 6.0;
    const dashSpace = 4.0;
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = (distance + dashWidth).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRoundedRectPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}
