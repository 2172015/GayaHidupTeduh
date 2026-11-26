import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/counseling_booking.dart';

class CounselingSessionCard extends StatelessWidget {
  final CounselingBooking booking;
  final VoidCallback onTap;

  const CounselingSessionCard({
    super.key,
    required this.booking,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final slot = booking.primaryItem;
    final counselor = slot.counselor;
    final status = booking.status;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.forestGreen.withValues(alpha: 0.16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
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
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Avatar dengan fallback placeholder
                Container(
                  width: 58,
                  height: 58,
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

                // Detail Sesi
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        counselor.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.forestGreen,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        counselor.role,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF383329),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              slot.formattedShortDateTime,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF383329),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: status.backgroundColor,
                              borderRadius: BorderRadius.circular(12),
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
