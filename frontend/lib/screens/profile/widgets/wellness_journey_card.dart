import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class WellnessJourneyCard extends StatelessWidget {
  final int streakDays;
  final int diaryCount;
  final int checkInCount;
  final int completedSessionsCount;

  const WellnessJourneyCard({
    super.key,
    required this.streakDays,
    required this.diaryCount,
    required this.checkInCount,
    required this.completedSessionsCount,
  });

  String get _treeAsset {
    if (streakDays >= 21) return 'assets/images/homepage/Streak4-png.png';
    if (streakDays >= 11) return 'assets/images/homepage/Streak3-png.png';
    if (streakDays >= 4) return 'assets/images/homepage/Streak2-png.png';
    return 'assets/images/homepage/Streak1-png.png';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.forestGreen.withValues(alpha: 0.25),
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
            'Perjalanan Teduhku',
            style: TextStyle(
              fontSize: 16.5,
              fontWeight: FontWeight.w700,
              color: AppColors.forestGreen,
            ),
          ),
          const SizedBox(height: 12),

          // Info Streak & Pohon Kehidupan
          Row(
            children: [
              Container(
                width: 50,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.offWhite,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Transform.scale(
                  scale: 1.45, // Ubah angka ini (misal 1.25 - 1.5) sesuai ukuran ruang kosong PNG
                  child: Image.asset(
                    _treeAsset,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.park_rounded,
                      color: AppColors.forestGreen,
                      size: 30,
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
                      '$streakDays Hari Streak',
                      style: const TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Pertahankan streakmu dengan mengisi Mood Tracker setiap hari',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.35,
                        color: Color(0xFF7A7E75),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(
            height: 1,
            color: AppColors.forestGreen.withValues(alpha: 0.15),
          ),
          const SizedBox(height: 14),

          // 3 Statistik Utama
          IntrinsicHeight(
            child: Row(
              children: [
                _buildStatColumn('$diaryCount', 'Diary'),
                VerticalDivider(
                  width: 1,
                  color: AppColors.forestGreen.withValues(alpha: 0.18),
                ),
                _buildStatColumn('$checkInCount', 'Check-In'),
                VerticalDivider(
                  width: 1,
                  color: AppColors.forestGreen.withValues(alpha: 0.18),
                ),
                _buildStatColumn('$completedSessionsCount', 'Sesi Selesai'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E1E1E),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF7A7E75)),
          ),
        ],
      ),
    );
  }
}
