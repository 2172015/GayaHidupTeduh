import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/counselor.dart';

class CounselorCard extends StatelessWidget {
  final Counselor counselor;
  final Set<String> selectedTimeSlots;
  final ValueChanged<String> onTimeSlotTapped;
  final VoidCallback onViewProfileTapped;

  const CounselorCard({
    super.key,
    required this.counselor,
    required this.selectedTimeSlots,
    required this.onTimeSlotTapped,
    required this.onViewProfileTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.forestGreen.withValues(alpha: 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kolom Kiri: Avatar, Rating, View Profile
          Column(
            children: [
              Container(
                width: 82,
                height: 82,
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
                      size: 44,
                      color: AppColors.forestGreen,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.star_rounded,
                    size: 16,
                    color: AppColors.forestGreen,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    '${counselor.rating}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.forestGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: onViewProfileTapped,
                child: const Text(
                  'View Profile',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.forestGreen,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),

          // Kolom Kanan: Nama, Role, Spesialisasi, Slot Jam, Harga
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  counselor.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.forestGreen,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  counselor.role,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: Color(0xFF383329),
                  ),
                ),
                Text(
                  counselor.specialty,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF383329),
                  ),
                ),
                const SizedBox(height: 10),

                // Chip Slot Jam
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: counselor.dailyTimeSlots.map((slot) {
                    final isBooked = counselor.isSlotBooked(slot);
                    final isSelected = selectedTimeSlots.contains(slot);

                    return GestureDetector(
                      onTap: isBooked ? null : () => onTimeSlotTapped(slot),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: isBooked
                              ? AppColors.offWhite
                              : isSelected
                              ? AppColors.sageGreen
                              : AppColors.pureWhite,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isBooked
                                ? const Color(0xFFCCCCCC)
                                : isSelected
                                ? AppColors.sageGreen
                                : AppColors.forestGreen,
                          ),
                        ),
                        child: Text(
                          slot,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            decoration: isBooked
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: isBooked
                                ? const Color(0xFFA8A8A8)
                                : const Color(0xFF1E1E1E),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),

                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    counselor.formattedFeePerSession,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF383329),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
