import 'package:flutter/material.dart';

enum CounselingSessionStatus {
  pendingPayment(
    label: 'Pending Payment',
    backgroundColor: Color(0xFFF5DFB5),
    textColor: Color(0xFFB36B16),
  ),
  scheduled(
    label: 'Scheduled',
    backgroundColor: Color(0xFFD3E3FD),
    textColor: Color(0xFF3367D6),
  ),
  completed(
    label: 'Completed',
    backgroundColor: Color(0xFFD8E8C8),
    textColor: Color(0xFF4A7729),
  ),
  cancelled(
    label: 'Cancelled',
    backgroundColor: Color(0xFFF8C6C6),
    textColor: Color(0xFFC63D3D),
  );

  final String label;
  final Color backgroundColor;
  final Color textColor;

  const CounselingSessionStatus({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  bool get isOngoing =>
      this == CounselingSessionStatus.pendingPayment ||
      this == CounselingSessionStatus.scheduled;
}
