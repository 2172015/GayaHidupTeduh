import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../models/counselor.dart';
import '../../services/counseling_service.dart';
import '../mood/widgets/mood_week_calendar.dart';
import '../payment/checkout_screen.dart';
import 'counselor_profile_screen.dart';
import 'widgets/counselor_card.dart';

class CounselorListScreen extends StatefulWidget {
  final String userId;
  final DateTime initialDate;
  final CounselingService counselingService;

  const CounselorListScreen({
    super.key,
    required this.userId,
    required this.initialDate,
    required this.counselingService,
  });

  @override
  State<CounselorListScreen> createState() => _CounselorListScreenState();
}

class _CounselorListScreenState extends State<CounselorListScreen> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  Set<String> _selectedSlotsFor(Counselor counselor) {
    return widget.counselingService
        .getCartItems()
        .where(
          (item) =>
              item.counselor.id == counselor.id &&
              item.date.year == _selectedDate.year &&
              item.date.month == _selectedDate.month &&
              item.date.day == _selectedDate.day,
        )
        .map((item) => item.timeSlot)
        .toSet();
  }

  Future<void> _openProfile(Counselor counselor) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => CounselorProfileScreen(
          userId: widget.userId,
          counselor: counselor,
          selectedDate: _selectedDate,
          counselingService: widget.counselingService,
        ),
      ),
    );
    setState(() {});
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
    final counselors = widget.counselingService.getCounselors();
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
                        'Counselors',
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

              // Strip Kalender Mingguan
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: MoodWeekCalendar(
                  selectedDate: _selectedDate,
                  onDateSelected: (d) => setState(() => _selectedDate = d),
                ),
              ),

              // Legend Booked
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 4, 24, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.circle, size: 10, color: Color(0xFF9E9E9E)),
                    SizedBox(width: 5),
                    Text(
                      'Booked',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF383329),
                      ),
                    ),
                  ],
                ),
              ),

              // Daftar Konselor
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  itemCount: counselors.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final counselor = counselors[index];
                    return CounselorCard(
                      counselor: counselor,
                      selectedTimeSlots: _selectedSlotsFor(counselor),
                      onTimeSlotTapped: (slot) {
                        setState(() {
                          widget.counselingService.toggleCartSlot(
                            counselor: counselor,
                            date: _selectedDate,
                            timeSlot: slot,
                          );
                        });
                      },
                      onViewProfileTapped: () => _openProfile(counselor),
                    );
                  },
                ),
              ),

              // Bottom Sticky Bar: X Session(s) Chosen / Book Appointment
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
