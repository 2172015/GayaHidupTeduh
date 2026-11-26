import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/booking_slot_item.dart';
import '../../../models/counselor.dart';

class CheckoutCounselorCard extends StatelessWidget {
  final Counselor counselor;
  final List<BookingSlotItem> slots;
  final String? message;
  final VoidCallback onEditTapped;
  final ValueChanged<BookingSlotItem> onDeleteSlot;
  final VoidCallback onMessageTapped;

  const CheckoutCounselorCard({
    super.key,
    required this.counselor,
    required this.slots,
    this.message,
    required this.onEditTapped,
    required this.onDeleteSlot,
    required this.onMessageTapped,
  });

  @override
  Widget build(BuildContext context) {
    final hasMessage = message != null && message!.trim().isNotEmpty;

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
          // Avatar
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
          const SizedBox(width: 12),

          // Detail Kanan
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        counselor.name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.forestGreen,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onEditTapped,
                      child: const Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.forestGreen,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  counselor.role,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF383329),
                  ),
                ),
                const SizedBox(height: 10),

                // Daftar Slot Jam + Tombol Hapus
                ...slots.map((slot) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.pureWhite,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppColors.forestGreen.withValues(
                                  alpha: 0.45,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    slot.formattedSchedule,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF1E1E1E),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  Counselor.formatRupiah(slot.fee),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1E1E1E),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => onDeleteSlot(slot),
                          child: const Icon(
                            Icons.delete_outline_rounded,
                            color: AppColors.errorRed,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                // Kolom Message
                const Text(
                  'Message',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
                const SizedBox(height: 4),
                InkWell(
                  onTap: onMessageTapped,
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 6),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.forestGreen.withValues(alpha: 0.25),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            hasMessage ? message! : 'Please leave a message',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: hasMessage
                                  ? const Color(0xFF383329)
                                  : const Color(0xFF9E9E9E),
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: 16,
                          color: Color(0xFF9E9E9E),
                        ),
                      ],
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
