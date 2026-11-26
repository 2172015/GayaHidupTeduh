import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_colors.dart';
import '../../core/navigation/app_navigator.dart';
import '../../models/counseling_booking.dart';
import '../../models/counseling_session_status.dart';
import '../../models/counselor.dart';
import '../../services/counseling_service.dart';
import '../../widgets/common/star_rating_selector.dart';
import '../../widgets/common/teduh_bottom_action_bar.dart';
import '../../widgets/common/teduh_loading_overlay.dart';
import '../../widgets/common/teduh_confirm_dialog.dart';
import '../../widgets/inputs/teduh_review_text_field.dart';
import '../../widgets/navigation/bottom_navigation_bar.dart';
import '../mailbox/session_mailbox_screen.dart';
import '../payment/checkout_screen.dart';
import 'counselor_notes_screen.dart';

class SessionDetailScreen extends StatefulWidget {
  final String userId;
  final CounselingBooking booking;
  final CounselingService counselingService;

  const SessionDetailScreen({
    super.key,
    required this.userId,
    required this.booking,
    required this.counselingService,
  });

  @override
  State<SessionDetailScreen> createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends State<SessionDetailScreen> {
  late CounselingBooking _booking;
  final _reviewController = TextEditingController();
  int _selectedRating = 5;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _booking = widget.booking;
    if (_booking.userRating != null) {
      _selectedRating = _booking.userRating!;
    }
    if (_booking.userReview != null) {
      _reviewController.text = _booking.userReview!;
    }
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _copyMeetLink() {
    Clipboard.setData(ClipboardData(text: _booking.meetLink));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Link Online Meet berhasil disalin.'),
        backgroundColor: AppColors.forestGreen,
      ),
    );
  }

  void _showOnlineMeetPopup() {
    showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: AppColors.offWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.videocam_rounded,
                    color: AppColors.forestGreen,
                    size: 26,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Online Counseling Room',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.forestGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Gunakan tautan di bawah ini untuk bergabung ke ruang konseling online bersama konselormu:',
                style: TextStyle(
                  fontSize: 13.5,
                  height: 1.4,
                  color: Color(0xFF383329),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.pureWhite,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.forestGreen.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  _booking.meetLink,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.forestGreen,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _copyMeetLink();
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 44),
                        side: const BorderSide(color: AppColors.forestGreen),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      icon: const Icon(
                        Icons.copy_rounded,
                        size: 16,
                        color: AppColors.forestGreen,
                      ),
                      label: const Text(
                        'Salin Link',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.forestGreen,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Membuka ${_booking.meetLink}...'),
                            backgroundColor: AppColors.forestGreen,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 44),
                        backgroundColor: AppColors.forestGreen,
                        foregroundColor: AppColors.pureWhite,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      child: const Text(
                        'Open',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _cancelSession() async {
    final confirmed = await TeduhConfirmDialog.show(
      context,
      title: 'Batalkan Sesi Konseling?',
      message:
          'Sesi ${_booking.sessionId} bersama ${_booking.primaryItem.counselor.name} akan dibatalkan.',
      confirmLabel: 'Batalkan Sesi',
      isDestructive: true,
    );

    if (!confirmed) return;

    setState(() => _isSubmitting = true);
    final updated = await widget.counselingService.cancelBooking(
      _booking.sessionId,
    );

    if (!mounted) return;
    setState(() {
      _booking = updated;
      _isSubmitting = false;
    });
  }

  Future<void> _completePayment() async {
    widget.counselingService.loadBookingIntoCart(_booking);
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => CheckoutScreen(
          userId: widget.userId,
          counselingService: widget.counselingService,
          existingPendingBooking: _booking,
        ),
      ),
    );
    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<void> _submitReview() async {
    final text = _reviewController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tuliskan ulasan singkatmu terlebih dahulu.'),
          backgroundColor: AppColors.errorRed,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final updated = await widget.counselingService.submitSessionReview(
      sessionId: _booking.sessionId,
      rating: _selectedRating,
      reviewText: text,
    );

    if (!mounted) return;
    setState(() {
      _booking = updated;
      _isSubmitting = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Terima kasih! Ulasanmu berhasil disimpan.'),
        backgroundColor: AppColors.forestGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final slot = _booking.primaryItem;
    final counselor = slot.counselor;
    final status = _booking.status;
    final isPending = status == CounselingSessionStatus.pendingPayment;
    final isScheduled = status == CounselingSessionStatus.scheduled;
    final isCompleted = status == CounselingSessionStatus.completed;

    return TeduhLoadingOverlay(
      isLoading: _isSubmitting,
      message: 'Mengirim ulasan...',
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.48, 1.0],
              colors: [
                AppColors.offWhite,
                AppColors.offWhite,
                Color(0xFF9AB08A),
              ],
            ),
          ),
          child: SafeArea(
            bottom: false,
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
                          'Session Details',
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
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
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
                                    size: 34,
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
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: status.backgroundColor,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                status.label,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: status.textColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.offWhite,
                            borderRadius: BorderRadius.circular(20),
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
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(18),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.event_available_rounded,
                                      size: 46,
                                      color: Color(0xFF383329),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            slot.formattedDateOnly,
                                            style: const TextStyle(
                                              fontSize: 16.5,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF383329),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            slot.timeSlot,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Color(0xFF383329),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 11,
                                ),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF2ECE1),
                                  borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(20),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Session ID: ${_booking.sessionId}',
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFB5AE9F),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (isScheduled) ...[
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: ElevatedButton.icon(
                                    onPressed: _showOnlineMeetPopup,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.forestGreen,
                                      foregroundColor: AppColors.pureWhite,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.videocam_rounded,
                                      color: AppColors.sageGreen,
                                      size: 24,
                                    ),
                                    label: const Text(
                                      'Join Online Meet',
                                      style: TextStyle(
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.pureWhite,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                width: 48,
                                height: 48,
                                child: OutlinedButton(
                                  onPressed: _copyMeetLink,
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    backgroundColor: AppColors.offWhite,
                                    minimumSize: const Size(48, 48),
                                    side: const BorderSide(
                                      color: AppColors.forestGreen,
                                      width: 1.5,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.copy_rounded,
                                    color: AppColors.forestGreen,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                        if (isScheduled || isCompleted) ...[
                          Row(
                            children: [
                              Expanded(
                                child: _buildActionSquareCard(
                                  icon: Icons.mail_outline_rounded,
                                  label: 'Mailbox',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (_) => SessionMailboxScreen(
                                          booking: _booking,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: _buildActionSquareCard(
                                  icon: Icons.assignment_outlined,
                                  label: 'Counselor Notes',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (_) => CounselorNotesScreen(
                                          booking: _booking,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.offWhite,
                            borderRadius: BorderRadius.circular(20),
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
                              const Text(
                                'Payment Details',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.forestGreen,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Session Fee',
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      color: Color(0xFF1E1E1E),
                                    ),
                                  ),
                                  Text(
                                    Counselor.formatRupiah(slot.fee),
                                    style: const TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF1E1E1E),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                height: 20,
                                color: AppColors.forestGreen.withValues(
                                  alpha: 0.2,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total Amount',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.forestGreen,
                                    ),
                                  ),
                                  Text(
                                    Counselor.formatRupiah(
                                      _booking.totalAmount,
                                    ),
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.forestGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (isScheduled) ...[
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerRight,
                            child: OutlinedButton(
                              onPressed: _isSubmitting ? null : _cancelSession,
                              style: OutlinedButton.styleFrom(
                                backgroundColor: const Color(0xFFF8BDBD),
                                foregroundColor: const Color(0xFFE05252),
                                minimumSize: const Size(110, 36),
                                side: const BorderSide(
                                  color: Color(0xFFE05252),
                                  width: 1.4,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Batalkan',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                        if (isCompleted) ...[
                          const SizedBox(height: 20),
                          const Text(
                            'Beri Ulasan Sesi Ini',
                            style: TextStyle(
                              fontSize: 16.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.forestGreen,
                            ),
                          ),
                          const SizedBox(height: 8),
                          StarRatingSelector(
                            rating: _selectedRating,
                            onRatingChanged: _booking.hasSubmittedReview
                                ? null
                                : (r) => setState(() => _selectedRating = r),
                          ),
                          const SizedBox(height: 10),
                          TeduhReviewTextField(
                            controller: _reviewController,
                            enabled: !_booking.hasSubmittedReview,
                          ),
                          if (!_booking.hasSubmittedReview) ...[
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              height: 44,
                              child: ElevatedButton(
                                onPressed: _isSubmitting ? null : _submitReview,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.forestGreen,
                                  foregroundColor: AppColors.pureWhite,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                ),
                                child: const Text(
                                  'Kirim Ulasan',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.pureWhite,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
                if (isPending)
                  TeduhBottomActionBar.primary(
                    label: 'Selesaikan Pembayaran',
                    onPressed: _completePayment,
                  ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: isPending
            ? null
            : TeduhBottomNav(
                currentIndex: 2,
                onTap: (index) => AppNavigator.onBottomNavTapped(
                  context,
                  currentIndex: 2,
                  targetIndex: index,
                ),
              ),
      ),
    );
  }

  Widget _buildActionSquareCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 112,
        decoration: BoxDecoration(
          color: AppColors.offWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.forestGreen.withValues(alpha: 0.2),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: const Color(0xFF383329)),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFF383329),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
