import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../models/counselor.dart';
import '../../services/counseling_service.dart';
import '../payment/checkout_screen.dart';
import '../../widgets/common/star_rating_selector.dart';

class CounselorProfileScreen extends StatefulWidget {
  final String userId;
  final Counselor counselor;
  final DateTime selectedDate;
  final CounselingService counselingService;

  const CounselorProfileScreen({
    super.key,
    required this.userId,
    required this.counselor,
    required this.selectedDate,
    required this.counselingService,
  });

  @override
  State<CounselorProfileScreen> createState() => _CounselorProfileScreenState();
}

class _CounselorProfileScreenState extends State<CounselorProfileScreen> {
  String get _formattedDatePill {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    final d = widget.selectedDate;
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  bool _isSlotSelected(String timeSlot) {
    return widget.counselingService.getCartItems().any(
      (item) =>
          item.counselor.id == widget.counselor.id &&
          item.date.year == widget.selectedDate.year &&
          item.date.month == widget.selectedDate.month &&
          item.date.day == widget.selectedDate.day &&
          item.timeSlot == timeSlot,
    );
  }

  Future<void> _openCheckout() async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => CheckoutScreen(
          userId: widget.userId,
          counselingService: widget.counselingService,
        ),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final counselor = widget.counselor;
    final cartCount = widget.counselingService.getCartItems().length;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.48, 1.0],
            colors: [AppColors.offWhite, AppColors.offWhite, Color(0xFF9AB08A)],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 24, 4),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.forestGreen,
                        size: 20,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'Counselor Profile',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.forestGreen,
                        ),
                      ),
                    ),
                    const SizedBox(width: 28),
                  ],
                ),
              ),

              // Konten Scrollable
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Info Utama Konselor
                      Row(
                        children: [
                          Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.sageGreen.withValues(
                                alpha: 0.35,
                              ),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                counselor.avatarAsset,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => const Icon(
                                  Icons.person_rounded,
                                  size: 48,
                                  color: AppColors.forestGreen,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  counselor.name,
                                  style: const TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.forestGreen,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  counselor.role,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF383329),
                                  ),
                                ),
                                Text(
                                  counselor.specialty,
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    color: Color(0xFF383329),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star_rounded,
                                      size: 16,
                                      color: AppColors.forestGreen,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${counselor.rating} (${counselor.reviewCount} Reviews)',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.forestGreen,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Bio
                      Text(
                        counselor.bio,
                        style: const TextStyle(
                          fontSize: 13.5,
                          height: 1.5,
                          color: Color(0xFF383329),
                        ),
                      ),
                      Divider(
                        height: 28,
                        color: AppColors.forestGreen.withValues(alpha: 0.25),
                      ),

                      // Choose Time + Date Pill
                      Row(
                        children: [
                          const Text(
                            'Choose Time',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF383329),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.offWhite,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.forestGreen),
                            ),
                            child: Text(
                              _formattedDatePill,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF383329),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Horizontal Time Slot Pills
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: counselor.dailyTimeSlots.map((slot) {
                            final isBooked = counselor.isSlotBooked(slot);
                            final isSelected = _isSlotSelected(slot);

                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: GestureDetector(
                                onTap: isBooked
                                    ? null
                                    : () {
                                        setState(() {
                                          widget.counselingService
                                              .toggleCartSlot(
                                                counselor: counselor,
                                                date: widget.selectedDate,
                                                timeSlot: slot,
                                              );
                                        });
                                      },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 7,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isBooked
                                        ? AppColors.offWhite
                                        : isSelected
                                        ? AppColors.sageGreen
                                        : AppColors.pureWhite,
                                    borderRadius: BorderRadius.circular(16),
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
                                      fontSize: 13,
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
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 10),

                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          counselor.formattedFeePerSession,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF383329),
                          ),
                        ),
                      ),
                      Divider(
                        height: 28,
                        color: AppColors.forestGreen.withValues(alpha: 0.25),
                      ),

                      // Reviews Section
                      Text(
                        '${counselor.reviewCount} Reviews',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF383329),
                        ),
                      ),
                      const SizedBox(height: 12),

                      ...counselor.reviews.map(
                        (review) => Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.offWhite,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.forestGreen.withValues(
                                alpha: 0.25,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    review.reviewerName,
                                    style: const TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1E1E1E),
                                    ),
                                  ),
                                  StarRatingSelector(
                                    rating: review.rating,
                                    size: 16,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                review.comment,
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
                    ],
                  ),
                ),
              ),

              // Bottom Sticky Bar
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.pureWhite,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 14),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: cartCount > 0 ? _openCheckout : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.sageGreen,
                          disabledBackgroundColor: const Color(0xFFD9D9D9),
                          foregroundColor: AppColors.forestGreen,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$cartCount Session(s) Chosen',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AppColors.forestGreen,
                              ),
                            ),
                            const Text(
                              'Book Appointment',
                              style: TextStyle(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.forestGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
