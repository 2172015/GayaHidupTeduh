import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class AboutTeduhScreen extends StatelessWidget {
  const AboutTeduhScreen({super.key});

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
                        'Tentang Aplikasi',
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
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
                  child: Column(
                    children: [
                      // Ikon & Versi Aplikasi
                      Container(
                        width: 84,
                        height: 84,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.pureWhite,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.forestGreen.withValues(alpha: 0.3),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/homepage/Streak4-png.png',
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.spa_rounded,
                            size: 42,
                            color: AppColors.forestGreen,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Gaya Hidup Teduh',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.forestGreen,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Versi 1.0.0',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF7A7E75),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Deskripsi Utama
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.offWhite,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.forestGreen.withValues(
                              alpha: 0.25,
                            ),
                          ),
                        ),
                        child: const Text(
                          'Gaya Hidup Teduh adalah ruang digital yang dirancang untuk menemanimu merawat kesehatan mental, mengenali emosi secara jujur, dan bertumbuh selangkah demi selangkah dalam keseharian.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13.5,
                            height: 1.5,
                            color: Color(0xFF383329),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Tiga Pilar Utama
                      _buildPillarCard(
                        icon: Icons.park_outlined,
                        title: 'Mood Tracker & Pohon Kehidupan',
                        description: 'Pantau 7 dimensi emosimu setiap hari dan rawat pertumbuhan Pohon Kehidupan melalui kebiasaan check-in yang konsisten.',
                      ),
                      const SizedBox(height: 12),
                      _buildPillarCard(
                        icon: Icons.auto_stories_outlined,
                        title: 'Me & My Everyday Story',
                        description: 'Ruang diary pribadi yang aman untuk merefleksikan keseharianmu melalui 5 aspek kehidupan (God, Beloved, Feeling, Lifestyle, Passion).',
                      ),
                      const SizedBox(height: 12),
                      _buildPillarCard(
                        icon: Icons.support_agent_rounded,
                        title: 'Konseling Profesional',
                        description: 'Terhubung langsung dengan konselor dan psikolog terpercaya melalui sesi daring terjadwal, catatan perkembangan, dan mailbox terpadu.',
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

  Widget _buildPillarCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.forestGreen.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.sageGreen.withValues(alpha: 0.28),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.forestGreen, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.forestGreen,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12.5,
                    height: 1.4,
                    color: Color(0xFF383329),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
