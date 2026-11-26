import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/navigation/app_navigator.dart';
import '../../models/counseling_booking.dart';
import '../../models/counselor.dart';
import '../../models/payment_method_type.dart';
import '../../services/counseling_service.dart';
import '../../widgets/common/teduh_loading_overlay.dart';

class PaymentGatewayScreen extends StatefulWidget {
  final CounselingBooking booking;
  final CounselingService counselingService;

  const PaymentGatewayScreen({
    super.key,
    required this.booking,
    required this.counselingService,
  });

  @override
  State<PaymentGatewayScreen> createState() => _PaymentGatewayScreenState();
}

class _PaymentGatewayScreenState extends State<PaymentGatewayScreen> {
  static const String _vaNumber = '8077 0812 3456 7890';
  int _remainingSeconds = 899; // 14:59
  Timer? _timer;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds -= 1);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedCountdown {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label berhasil disalin.'),
        backgroundColor: AppColors.forestGreen,
      ),
    );
  }

  Future<void> _verifyPaymentStatus() async {
    setState(() => _isVerifying = true);
    await widget.counselingService.confirmPayment(widget.booking.sessionId);
    if (!mounted) return;
    setState(() => _isVerifying = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Pembayaran terverifikasi! Sesi konselingmu telah terjadwal.',
        ),
        backgroundColor: AppColors.forestGreen,
      ),
    );

    AppNavigator.toCounseling(context);
  }

  @override
  Widget build(BuildContext context) {
    final formattedTotal = Counselor.formatRupiah(widget.booking.totalAmount);
    final isQris = widget.booking.paymentMethod == PaymentMethodType.qris;

    return TeduhLoadingOverlay(
      isLoading: _isVerifying,
      message: 'Memeriksa status pembayaran...',
      child: Scaffold(
        backgroundColor: AppColors.offWhite,
        body: SafeArea(
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
                        'Payment',
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

              // Banner Countdown Kuning
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                color: const Color(0xFFFCE3C3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.warning_rounded,
                      color: Color(0xFFD9822B),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Complete payment within $_formattedCountdown',
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF7D4B16),
                      ),
                    ),
                  ],
                ),
              ),

              // Konten Utama
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Payment',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF383329),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        formattedTotal,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF383329),
                        ),
                      ),
                      const SizedBox(height: 16),

                      if (isQris)
                        _buildQrisCard()
                      else
                        _buildBcaCard(formattedTotal),

                      const SizedBox(height: 20),
                      const Text(
                        'Cara Pembayaran',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF383329),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ..._buildInstructions(isQris),
                    ],
                  ),
                ),
              ),

              // Tombol Cek Status Pembayaran
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 18),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isVerifying ? null : _verifyPaymentStatus,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.forestGreen,
                      foregroundColor: AppColors.pureWhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Cek Status Pembayaran',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.pureWhite,
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

  Widget _buildBcaCard(String formattedTotal) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                height: 24,
                child: Image.asset(
                  'assets/images/payment/Logo BCA.png',
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => const Text(
                    'BCA',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF00529C),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'BCA Virtual Account',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF383329),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Nomor Virtual Account',
            style: TextStyle(fontSize: 13, color: Color(0xFF383329)),
          ),
          const SizedBox(height: 4),
          Text(
            _vaNumber,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: Color(0xFF383329),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: () =>
                  _copyToClipboard(_vaNumber.replaceAll(' ', ''), 'Nomor VA'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 36),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                side: const BorderSide(color: Color(0xFF9E9E9E)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(
                Icons.copy_rounded,
                size: 16,
                color: Color(0xFF383329),
              ),
              label: const Text(
                'Salin',
                style: TextStyle(fontSize: 13.5, color: Color(0xFF383329)),
              ),
            ),
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Payment',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF383329),
                    ),
                  ),
                  Text(
                    'Total Pembayaran',
                    style: TextStyle(fontSize: 11, color: Color(0xFF7A7E75)),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    formattedTotal,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF383329),
                    ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () => _copyToClipboard(
                      widget.booking.totalAmount.toString(),
                      'Nominal pembayaran',
                    ),
                    child: const Icon(
                      Icons.copy_rounded,
                      size: 18,
                      color: Color(0xFF383329),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQrisCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 28,
            child: Image.asset(
              'assets/images/payment/Logo QRIS.png',
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const Text(
                'QRIS',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  color: Color(0xFF1E1E1E),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: 195,
            height: 195,
            child: Image.asset(
              'assets/images/payment/QR Example.png',
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => Container(
                decoration: BoxDecoration(
                  color: AppColors.offWhite,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.forestGreen.withValues(alpha: 0.3),
                  ),
                ),
                child: const Icon(
                  Icons.qr_code_2_rounded,
                  size: 145,
                  color: Color(0xFF1E1E1E),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'GAYA HIDUP TEDUH',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF383329),
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'NMID: ID102030405060',
            style: TextStyle(fontSize: 12, color: Color(0xFF7A7E75)),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Kode QRIS berhasil disimpan ke galeri.'),
                    backgroundColor: AppColors.forestGreen,
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF9E9E9E)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(
                Icons.download_rounded,
                size: 18,
                color: Color(0xFF383329),
              ),
              label: const Text(
                'Unduh QRIS',
                style: TextStyle(fontSize: 14, color: Color(0xFF383329)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildInstructions(bool isQris) {
    final steps = isQris
        ? [
            '1. Buka aplikasi e-wallet atau mobile banking anda (Gojek, OVO, BCA, dll).',
            '2. Scan QR code diatas atau upload gambar QR.',
            '3. Pastikan nominal dan nama akun sesuai.',
            '4. Masukan PIN dan selesaikan transaksi.',
            '5. Tekan tombol "Cek Status Pembayaran" untuk melihat status pembayaran saat ini.',
          ]
        : [
            '1. Buka aplikasi mobile banking BCA anda.',
            '2. Pilih "transfer BCA Virtual Account".',
            '3. Masukkan nomor Virtual account: 8077 0812 3456 7890.',
            '4. Periksa ulang nominal.',
            '5. Masukan PIN dan selesaikan transaksi.',
            '6. Tekan tombol "Cek Status Pembayaran" untuk melihat status pembayaran saat ini.',
          ];

    return steps
        .map(
          (s) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              s,
              style: const TextStyle(
                fontSize: 12.5,
                height: 1.4,
                color: Color(0xFF383329),
              ),
            ),
          ),
        )
        .toList();
  }
}
