import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../models/mood_dimension.dart';
import '../../../models/mood_record.dart';

class MoodEmotionBreakdownCard extends StatelessWidget {
  final MoodRecord record;

  const MoodEmotionBreakdownCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Detail 7 Emosi',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E1E1E),
            ),
          ),
          const SizedBox(height: 14),
          ...MoodDimension.historyDisplayOrder.map((dimension) {
            final score = record.scoreFor(dimension);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  SizedBox(
                    width: 68,
                    child: Text(
                      dimension.label,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: score / 10,
                        minHeight: 10,
                        backgroundColor: AppColors.offWhite,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          dimension.barColorForScore(score),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 44,
                    child: Text(
                      '$score/10',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
