import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/counseling_booking.dart';

class CounselorSessionHeader extends StatelessWidget {
  final CounselingBooking booking;
  final bool showSessionIdBadge;

  const CounselorSessionHeader({
    super.key,
    required this.booking,
    this.showSessionIdBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    final counselor = booking.primaryItem.counselor;
    final status = booking.status;

    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.sageGreen.withValues(alpha: 0.35),
              ),
              child: ClipOval(
                child: Image.asset(
                  counselor.avatarAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const Icon(
                    Icons.person_rounded,
                    size: 32,
                    color: AppColors.forestGreen,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    counselor.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.forestGreen,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    counselor.role,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF383329),
                    ),
                  ),
                  if (showSessionIdBadge) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD6D2C9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Session ID: ${booking.sessionId}',
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.pureWhite,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
              decoration: BoxDecoration(
                color: status.backgroundColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                status.label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: status.textColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Divider(
          height: 1,
          color: AppColors.forestGreen.withValues(alpha: 0.25),
        ),
      ],
    );
  }
}
