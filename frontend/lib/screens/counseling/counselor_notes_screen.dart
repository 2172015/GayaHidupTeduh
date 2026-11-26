import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/navigation/app_navigator.dart';
import '../../models/counseling_booking.dart';
import '../../widgets/navigation/bottom_navigation_bar.dart';
import '../mailbox/widgets/counselor_session_header.dart';

class CounselorNotesScreen extends StatelessWidget {
  final CounselingBooking booking;

  const CounselorNotesScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final notes = booking.notes;

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
          child: Column(
            children: [
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
                        'Notes',
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
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 14),
                child: CounselorSessionHeader(
                  booking: booking,
                  showSessionIdBadge: false,
                ),
              ),
              Expanded(
                child: notes.isEmpty
                    ? const Center(
                        child: Text(
                          'Belum ada catatan dari konselor untuk sesi ini.',
                          style: TextStyle(
                            fontSize: 13.5,
                            color: Color(0xFF383329),
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                        itemCount: notes.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final note = notes[index];
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.offWhite,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: AppColors.forestGreen.withValues(
                                  alpha: 0.2,
                                ),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  note.formattedDate,
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF8C877D),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  note.content,
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    height: 1.45,
                                    color: Color(0xFF1E1E1E),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: TeduhBottomNav(
        currentIndex: 2,
        onTap: (index) => AppNavigator.onBottomNavTapped(
          context,
          currentIndex: 2,
          targetIndex: index,
        ),
      ),
    );
  }
}
