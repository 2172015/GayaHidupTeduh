import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../services/counseling_service.dart';
import 'counselor_list_screen.dart';
import 'widgets/booking_calendar_card.dart';

class BookSessionDateScreen extends StatefulWidget {
  final String userId;
  final CounselingService counselingService;

  const BookSessionDateScreen({
    super.key,
    required this.userId,
    required this.counselingService,
  });

  @override
  State<BookSessionDateScreen> createState() => _BookSessionDateScreenState();
}

class _BookSessionDateScreenState extends State<BookSessionDateScreen> {
  DateTime _selectedDate = DateTime(2026, 11, 19);

  void _goToChooseCounselor() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => CounselorListScreen(
          userId: widget.userId,
          initialDate: _selectedDate,
          counselingService: widget.counselingService,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
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
                        'Book Sessions',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.forestGreen,
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
                const SizedBox(height: 16),

                const Text(
                  'Pilih Tanggal',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.forestGreen,
                  ),
                ),
                const SizedBox(height: 14),

                BookingCalendarCard(
                  selectedDate: _selectedDate,
                  onDateSelected: (date) =>
                      setState(() => _selectedDate = date),
                ),
                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _goToChooseCounselor,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.sageGreen,
                      foregroundColor: AppColors.forestGreen,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Choose counselor',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.forestGreen,
                      ),
                    ),
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
