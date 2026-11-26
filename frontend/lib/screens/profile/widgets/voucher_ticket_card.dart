import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/voucher.dart';

class VoucherTicketCard extends StatelessWidget {
  final Voucher voucher;
  final VoidCallback? onUsePressed;

  const VoucherTicketCard({
    super.key,
    required this.voucher,
    this.onUsePressed,
  });

  @override
  Widget build(BuildContext context) {
    final isAvailable = voucher.isAvailable;
    final isPercentage = voucher.discountType == VoucherDiscountType.percentage;

    final leftBandColor = !isAvailable
        ? const Color(0xFFE5E3DC)
        : isPercentage
        ? const Color(0xFFE9D8A6)
        : const Color(0xFFDCEAD1);

    final iconColor = !isAvailable
        ? const Color(0xFF9E9E9E)
        : isPercentage
        ? const Color(0xFF9C7A3C)
        : AppColors.forestGreen;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isAvailable ? AppColors.pureWhite : AppColors.offWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.forestGreen.withValues(alpha: 0.22),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(17),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Bagian Kiri (Ikon Tiket & Label Potongan)
              Container(
                width: 88,
                color: leftBandColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 14,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.confirmation_number_rounded,
                      size: 32,
                      color: iconColor,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      voucher.formattedDiscountBadge,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: iconColor,
                      ),
                    ),
                  ],
                ),
              ),

              // Pemisah Vertikal Putus-Putus dengan Notch Atas & Bawah
              SizedBox(
                width: 16,
                child: CustomPaint(
                  painter: _TicketDividerPainter(
                    notchFillColor: AppColors.offWhite,
                    dashColor: AppColors.forestGreen.withValues(alpha: 0.35),
                  ),
                ),
              ),

              // Bagian Kanan (Judul, Deskripsi, Masa Berlaku, Tombol Pakai)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4, 14, 14, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        voucher.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isAvailable
                              ? const Color(0xFF1E1E1E)
                              : const Color(0xFF7A7E75),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        voucher.description,
                        style: TextStyle(
                          fontSize: 12.5,
                          height: 1.35,
                          color: isAvailable
                              ? const Color(0xFF383329)
                              : const Color(0xFF8C9087),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        voucher.formattedExpiry,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF8C9087),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.offWhite,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.forestGreen.withValues(
                                  alpha: 0.2,
                                ),
                              ),
                            ),
                            child: Text(
                              voucher.code,
                              style: const TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.4,
                                color: Color(0xFF5A5E56),
                              ),
                            ),
                          ),
                          if (isAvailable)
                            SizedBox(
                              height: 32,
                              child: ElevatedButton(
                                onPressed: onUsePressed,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.sageGreen,
                                  foregroundColor: AppColors.forestGreen,
                                  minimumSize: const Size(74, 32),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                child: const Text(
                                  'Pakai',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.forestGreen,
                                  ),
                                ),
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: voucher.isUsed
                                    ? const Color(0xFFD8E8C8)
                                    : const Color(0xFFF8C6C6),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                voucher.isUsed ? 'Terpakai' : 'Kedaluwarsa',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: voucher.isUsed
                                      ? const Color(0xFF4A7729)
                                      : const Color(0xFFC63D3D),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
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

class _TicketDividerPainter extends CustomPainter {
  final Color notchFillColor;
  final Color dashColor;

  const _TicketDividerPainter({
    required this.notchFillColor,
    required this.dashColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    const notchRadius = 7.0;

    final dashPaint = Paint()
      ..color = dashColor
      ..strokeWidth = 1.4;

    double y = notchRadius + 4;
    while (y < size.height - notchRadius - 4) {
      canvas.drawLine(
        Offset(centerX, y),
        Offset(centerX, (y + 4).clamp(0, size.height - notchRadius)),
        dashPaint,
      );
      y += 8;
    }

    final notchPaint = Paint()..color = notchFillColor;
    canvas.drawCircle(Offset(centerX, 0), notchRadius, notchPaint);
    canvas.drawCircle(Offset(centerX, size.height), notchRadius, notchPaint);
  }

  @override
  bool shouldRepaint(covariant _TicketDividerPainter oldDelegate) => false;
}
