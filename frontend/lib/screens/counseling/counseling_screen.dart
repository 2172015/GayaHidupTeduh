import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/navigation/app_navigator.dart';
import '../../models/counseling_booking.dart';
import '../../services/counseling_service.dart';
import '../../widgets/navigation/bottom_navigation_bar.dart';
import '../booking/book_session_date_screen.dart';
import '../payment/checkout_screen.dart';
import 'session_detail_screen.dart';
import 'widgets/counseling_session_card.dart';
import 'widgets/pending_cart_card.dart';

class CounselingScreen extends StatefulWidget {
  final String userId;
  final CounselingService? counselingService;

  const CounselingScreen({
    super.key,
    this.userId = '278392',
    this.counselingService,
  });

  @override
  State<CounselingScreen> createState() => _CounselingScreenState();
}

class _CounselingScreenState extends State<CounselingScreen> {
  late final CounselingService _counselingService;
  List<CounselingBooking> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _counselingService = widget.counselingService ?? MockCounselingService();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    setState(() => _isLoading = true);
    final items = await _counselingService.getUserBookings(widget.userId);
    if (!mounted) return;
    setState(() {
      _bookings = items;
      _isLoading = false;
    });
  }

  Future<void> _openBookNewSession() async {
    _counselingService.clearCart();
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => BookSessionDateScreen(
          userId: widget.userId,
          counselingService: _counselingService,
        ),
      ),
    );
    _loadBookings();
  }

  Future<void> _handleBookingCardTap(CounselingBooking booking) async {
    // Jika Pending Payment dengan > 1 sesi (keranjang multi-sesi), langsung ke Checkout
    if (booking.isMultiSession) {
      _counselingService.loadBookingIntoCart(booking);
      await Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (_) => CheckoutScreen(
            userId: widget.userId,
            counselingService: _counselingService,
            existingPendingBooking: booking,
          ),
        ),
      );
      _loadBookings();
      return;
    }

    // Jika 1 sesi (Pending Payment, Scheduled, Completed, Cancelled), buka Session Details
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => SessionDetailScreen(
          userId: widget.userId,
          booking: booking,
          counselingService: _counselingService,
        ),
      ),
    );
    _loadBookings();
  }

  @override
  Widget build(BuildContext context) {
    final ongoing = _bookings.where((b) => b.status.isOngoing).toList();
    final history = _bookings.where((b) => !b.status.isOngoing).toList();
    final isEmpty = _bookings.isEmpty;

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
          child: RefreshIndicator(
            color: AppColors.forestGreen,
            onRefresh: _loadBookings,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Gaya Hidup Teduh',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF7D9378),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Counseling',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.forestGreen,
                    ),
                  ),
                  const SizedBox(height: 18),

                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 64),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.forestGreen,
                        ),
                      ),
                    )
                  else if (isEmpty) ...[
                    // Tampilan Empty State sesuai mockup
                    _buildBookButton(isLargeEmpty: true),
                    const SizedBox(height: 96),
                    const Center(
                      child: Text(
                        "You don't have any session history",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF383329),
                        ),
                      ),
                    ),
                  ] else ...[
                    _buildBookButton(isLargeEmpty: false),
                    const SizedBox(height: 22),

                    if (ongoing.isNotEmpty) ...[
                      const Text(
                        'Ongoing Sessions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.forestGreen,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...ongoing.map(
                        (booking) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: booking.isMultiSession
                              ? PendingCartCard(
                                  booking: booking,
                                  onTap: () => _handleBookingCardTap(booking),
                                )
                              : CounselingSessionCard(
                                  booking: booking,
                                  onTap: () => _handleBookingCardTap(booking),
                                ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    if (history.isNotEmpty) ...[
                      const Text(
                        'Session History',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.forestGreen,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...history.map(
                        (booking) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: CounselingSessionCard(
                            booking: booking,
                            onTap: () => _handleBookingCardTap(booking),
                          ),
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
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

  Widget _buildBookButton({required bool isLargeEmpty}) {
    return InkWell(
      onTap: _openBookNewSession,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: double.infinity,
        height: isLargeEmpty ? 116 : 48,
        decoration: BoxDecoration(
          color: AppColors.offWhite,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.forestGreen, width: 1.8),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Book New Session',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.forestGreen,
              ),
            ),
            SizedBox(width: 10),
            Icon(
              Icons.add_circle_outline_rounded,
              color: AppColors.forestGreen,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
