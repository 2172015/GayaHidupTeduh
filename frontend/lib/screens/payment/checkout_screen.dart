import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/booking_slot_item.dart';
import '../../models/counseling_booking.dart';
import '../../models/counselor.dart';
import '../../models/payment_method_type.dart';
import '../../models/voucher.dart';
import '../../services/counseling_service.dart';
import '../../services/voucher_service.dart';
import '../../widgets/common/teduh_bottom_action_bar.dart';
import '../../widgets/common/teduh_loading_overlay.dart';
import '../../widgets/inputs/teduh_review_text_field.dart';
import '../booking/counselor_list_screen.dart';
import 'payment_gateway_screen.dart';
import 'widgets/checkout_counselor_card.dart';

class CheckoutScreen extends StatefulWidget {
  final String userId;
  final CounselingService counselingService;
  final CounselingBooking? existingPendingBooking;

  const CheckoutScreen({
    super.key,
    required this.userId,
    required this.counselingService,
    this.existingPendingBooking,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late PaymentMethodType _selectedPaymentMethod;
  late Map<String, String> _messages;
  bool _isProcessing = false;

  final VoucherService _voucherService = MockVoucherService();
  Voucher? _appliedVoucher;

  @override
  void initState() {
    super.initState();
    _selectedPaymentMethod =
        widget.existingPendingBooking?.paymentMethod ??
        PaymentMethodType.bcaVirtualAccount;
    _messages = Map<String, String>.from(
      widget.existingPendingBooking?.counselorMessages ?? {},
    );
    _appliedVoucher = _voucherService.getSelectedVoucher();
  }

  Map<String, List<BookingSlotItem>> _groupByCounselor(
    List<BookingSlotItem> items,
  ) {
    final grouped = <String, List<BookingSlotItem>>{};
    for (final item in items) {
      grouped.putIfAbsent(item.counselor.id, () => []).add(item);
    }
    return grouped;
  }

  Future<void> _editCounselorSlots(DateTime referenceDate) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => CounselorListScreen(
          userId: widget.userId,
          initialDate: referenceDate,
          counselingService: widget.counselingService,
        ),
      ),
    );
    setState(() {});
  }

  Future<void> _openMessageDialog(Counselor counselor) async {
    final controller = TextEditingController(
      text: _messages[counselor.id] ?? '',
    );

    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: AppColors.offWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pesan untuk ${counselor.name}',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.forestGreen,
                ),
              ),
              const SizedBox(height: 12),
              TeduhReviewTextField(
                controller: controller,
                hintText: 'Tuliskan keluhan atau topik yang ingin dibahas...',
                maxLines: 3,
                maxLength: 200,
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 42),
                        side: const BorderSide(color: AppColors.forestGreen),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(color: AppColors.forestGreen),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx, controller.text),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 42),
                        backgroundColor: AppColors.sageGreen,
                        foregroundColor: AppColors.forestGreen,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      child: const Text(
                        'Simpan',
                        style: TextStyle(fontWeight: FontWeight.w700),
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

    if (result != null && mounted) {
      setState(() => _messages[counselor.id] = result.trim());
    }
  }

  void _removeAppliedVoucher() {
    _voucherService.selectVoucherForBooking(null);
    setState(() => _appliedVoucher = null);
  }

  Future<void> _proceedToPayment() async {
    final items = widget.counselingService.getCartItems();
    if (items.isEmpty) return;

    setState(() => _isProcessing = true);

    final subtotal = items.fold<int>(0, (sum, i) => sum + i.fee);
    final discount = _appliedVoucher?.calculateDiscount(subtotal) ?? 0;

    if (_appliedVoucher != null && discount > 0) {
      await _voucherService.markVoucherAsUsed(_appliedVoucher!.id);
    }

    final pendingBooking = await widget.counselingService.createPendingBooking(
      userId: widget.userId,
      items: items,
      messages: _messages,
      paymentMethod: _selectedPaymentMethod,
      existingPendingSessionId: widget.existingPendingBooking?.sessionId,
    );

    if (!mounted) return;
    setState(() {
      _appliedVoucher = null;
      _isProcessing = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => PaymentGatewayScreen(
          booking: pendingBooking,
          counselingService: widget.counselingService,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.counselingService.getCartItems();
    final grouped = _groupByCounselor(items);
    final subtotal = items.fold<int>(0, (sum, i) => sum + i.fee);
    final discount = _appliedVoucher?.calculateDiscount(subtotal) ?? 0;
    final totalAmount = subtotal - discount;

    return TeduhLoadingOverlay(
      isLoading: _isProcessing,
      message: 'Menyiapkan pembayaran...',
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
                          'Checkout',
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

                // Konten Checkout
                Expanded(
                  child: items.isEmpty
                      ? const Center(
                          child: Text(
                            'Tidak ada sesi yang dipilih.',
                            style: TextStyle(color: Color(0xFF383329)),
                          ),
                        )
                      : SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Your Booked Sessions',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.forestGreen,
                                ),
                              ),
                              const SizedBox(height: 12),

                              ...grouped.entries.map((entry) {
                                final counselorSlots = entry.value;
                                final counselor =
                                    counselorSlots.first.counselor;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 14),
                                  child: CheckoutCounselorCard(
                                    counselor: counselor,
                                    slots: counselorSlots,
                                    message: _messages[counselor.id],
                                    onEditTapped: () => _editCounselorSlots(
                                      counselorSlots.first.date,
                                    ),
                                    onDeleteSlot: (slot) {
                                      setState(() {
                                        widget.counselingService.removeCartSlot(
                                          slot.id,
                                        );
                                      });
                                    },
                                    onMessageTapped: () =>
                                        _openMessageDialog(counselor),
                                  ),
                                );
                              }),

                              // Payment Methods Card
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.offWhite,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppColors.forestGreen.withValues(
                                      alpha: 0.25,
                                    ),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.08,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Payment Methods',
                                      style: TextStyle(
                                        fontSize: 16.5,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.forestGreen,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    ...PaymentMethodType.values.map((method) {
                                      final isSelected =
                                          _selectedPaymentMethod == method;
                                      return InkWell(
                                        onTap: () => setState(
                                          () => _selectedPaymentMethod = method,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 6,
                                          ),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 40,
                                                height: 28,
                                                child: Image.asset(
                                                  method.logoAsset,
                                                  fit: BoxFit.contain,
                                                  errorBuilder: (_, _, _) => Icon(
                                                    method ==
                                                            PaymentMethodType
                                                                .qris
                                                        ? Icons.qr_code_rounded
                                                        : Icons
                                                              .account_balance_rounded,
                                                    color: const Color(
                                                      0xFF1E1E1E,
                                                    ),
                                                    size: 24,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      method.title,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Color(
                                                          0xFF1E1E1E,
                                                        ),
                                                      ),
                                                    ),
                                                    if (method ==
                                                        PaymentMethodType
                                                            .bcaVirtualAccount)
                                                      Text(
                                                        method.subtitle,
                                                        style: const TextStyle(
                                                          fontSize: 11.5,
                                                          color: Color(
                                                            0xFF7A7E75,
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                              Icon(
                                                isSelected
                                                    ? Icons.check_circle_rounded
                                                    : Icons.circle_outlined,
                                                color: isSelected
                                                    ? AppColors.forestGreen
                                                    : const Color(0xFFBDBDBD),
                                                size: 22,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),

                              // Payment Details Card
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.offWhite,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppColors.forestGreen.withValues(
                                      alpha: 0.25,
                                    ),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.08,
                                      ),
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
                                        fontSize: 16.5,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.forestGreen,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    ...grouped.entries.map((entry) {
                                      final c = entry.value.first.counselor;
                                      final subTotal = entry.value.fold<int>(
                                        0,
                                        (sum, s) => sum + s.fee,
                                      );
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 6,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Session Fee (${c.name})',
                                                style: const TextStyle(
                                                  fontSize: 13.5,
                                                  color: Color(0xFF1E1E1E),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              Counselor.formatRupiah(subTotal),
                                              style: const TextStyle(
                                                fontSize: 13.5,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF1E1E1E),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),

                                    // Baris Potongan Voucher
                                    if (_appliedVoucher != null) ...[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 2,
                                          bottom: 6,
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      'Voucher (${_appliedVoucher!.code})',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 13.5,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: discount > 0
                                                            ? const Color(
                                                                0xFF4A7729,
                                                              )
                                                            : const Color(
                                                                0xFF8C9087,
                                                              ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  GestureDetector(
                                                    onTap:
                                                        _removeAppliedVoucher,
                                                    child: const Icon(
                                                      Icons.close_rounded,
                                                      size: 16,
                                                      color: AppColors.errorRed,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              discount > 0
                                                  ? '- ${Counselor.formatRupiah(discount)}'
                                                  : 'Min. ${Counselor.formatRupiah(_appliedVoucher!.minTransaction)}',
                                              style: TextStyle(
                                                fontSize: 13.5,
                                                fontWeight: FontWeight.w600,
                                                color: discount > 0
                                                    ? const Color(0xFF4A7729)
                                                    : const Color(0xFF8C9087),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],

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
                                          Counselor.formatRupiah(totalAmount),
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
                            ],
                          ),
                        ),
                ),

                TeduhBottomActionBar.primary(
                  label: 'Proceed to Payment',
                  isDisabled: items.isEmpty || _isProcessing,
                  onPressed: _proceedToPayment,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
