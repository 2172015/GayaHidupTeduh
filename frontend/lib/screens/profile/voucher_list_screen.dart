import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/navigation/app_navigator.dart';
import '../../models/voucher.dart';
import '../../services/voucher_service.dart';
import '../../widgets/navigation/bottom_navigation_bar.dart';
import 'widgets/voucher_ticket_card.dart';

class VoucherListScreen extends StatefulWidget {
  final String userId;
  final VoucherService? voucherService;

  const VoucherListScreen({
    super.key,
    required this.userId,
    this.voucherService,
  });

  @override
  State<VoucherListScreen> createState() => _VoucherListScreenState();
}

class _VoucherListScreenState extends State<VoucherListScreen> {
  late final VoucherService _voucherService;
  List<Voucher> _vouchers = [];
  bool _showAvailableTab = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _voucherService = widget.voucherService ?? MockVoucherService();
    _loadVouchers();
  }

  Future<void> _loadVouchers() async {
    setState(() => _isLoading = true);
    final list = await _voucherService.getUserVouchers(widget.userId);
    if (!mounted) return;
    setState(() {
      _vouchers = list;
      _isLoading = false;
    });
  }

  void _useVoucherAndBook(Voucher voucher) {
    _voucherService.selectVoucherForBooking(voucher);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Voucher "${voucher.code}" dipilih untuk sesi konseling.',
        ),
        backgroundColor: AppColors.forestGreen,
      ),
    );
    AppNavigator.toBookSession(context);
  }

  @override
  Widget build(BuildContext context) {
    final availableList = _vouchers.where((v) => v.isAvailable).toList();
    final historyList = _vouchers.where((v) => !v.isAvailable).toList();
    final displayedList = _showAvailableTab ? availableList : historyList;

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
              // Top Bar
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
                        'Voucher Saya',
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

              // Toggle Tabs (Tersedia & Riwayat)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 10, 24, 16),
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.pureWhite,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppColors.forestGreen.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _showAvailableTab = true),
                          child: Container(
                            decoration: BoxDecoration(
                              color: _showAvailableTab
                                  ? AppColors.forestGreen
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Tersedia (${availableList.length})',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: _showAvailableTab
                                    ? AppColors.pureWhite
                                    : AppColors.forestGreen,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _showAvailableTab = false),
                          child: Container(
                            decoration: BoxDecoration(
                              color: !_showAvailableTab
                                  ? AppColors.forestGreen
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Riwayat (${historyList.length})',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: !_showAvailableTab
                                    ? AppColors.pureWhite
                                    : AppColors.forestGreen,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Daftar Voucher
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.forestGreen,
                        ),
                      )
                    : displayedList.isEmpty
                    ? Center(
                        child: Text(
                          _showAvailableTab
                              ? 'Belum ada voucher tersedia saat ini.'
                              : 'Belum ada riwayat penggunaan voucher.',
                          style: const TextStyle(
                            fontSize: 13.5,
                            color: Color(0xFF383329),
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                        itemCount: displayedList.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final voucher = displayedList[index];
                          return VoucherTicketCard(
                            voucher: voucher,
                            onUsePressed: voucher.isAvailable
                                ? () => _useVoucherAndBook(voucher)
                                : null,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: TeduhBottomNav(
        currentIndex: 3,
        onTap: (index) => AppNavigator.onBottomNavTapped(
          context,
          currentIndex: 3,
          targetIndex: index,
        ),
      ),
    );
  }
}
