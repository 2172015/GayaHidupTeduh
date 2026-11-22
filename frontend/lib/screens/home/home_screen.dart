import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../widgets/bottom_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({super.key, this.username = 'User'});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNavIndex = 0;
  final int _streakDays = 30;

  void _onNavTapped(int index) {
    setState(() {
      _selectedNavIndex = index;
    });
  }

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. Header Row: Greeting + Circular Profile Box
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, ${widget.username}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.forestGreen,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Bagaimana perasaanmu hari ini?',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w400,
                            color: AppColors.forestGreen,
                          ),
                        ),
                      ],
                    ),

                    // Circular Profile Picture Box
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.pureWhite,
                        border: Border.all(
                          color: AppColors.forestGreen,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/profilepicture/pp1.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 2. Pohon Kehidupan Title
                const Text(
                  'Pohon Kehidupan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.forestGreen,
                  ),
                ),
                const SizedBox(height: 12),

                // 3. Tree Streak Graphic
                // 3. Tree Streak Graphic with Dynamic Stack Overlay
                SizedBox(
                  width: 240,
                  height: 240,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Base Tree & Circle Background Image
                      Image.asset(
                        'assets/images/homepage/Tree Streak.png',
                        width: 240,
                        height: 240,
                        fit: BoxFit.contain,
                      ),

                      // Watering Can + Dynamic Streak Text on the Brown Soil
                      Positioned(
                        bottom: 50,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.water_drop_rounded,
                              color: Color(0xFF90D5FF),
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$_streakDays Hari',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: AppColors.pureWhite,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // 4. Mood Tracker Pill Button (Sand Color #E9D8A6)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.14),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Navigate to MoodTrackerScreen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.sand,
                      foregroundColor: AppColors.forestGreen,
                      minimumSize: const Size(150, 40),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      textStyle: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 17.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('Mood Tracker'),
                  ),
                ),
                const SizedBox(height: 26),

                // 5. Card 1: Me & My Everyday Story
                _FeatureCard(
                  backgroundColor: AppColors.sageGreen,
                  borderColor: AppColors.lightForestGreen.withValues(
                    alpha: 0.4,
                  ),
                  title: 'Me & My Everyday Story',
                  subtitle: 'Ruang aman untuk ceritamu. Tuangkan pikiran dan temukan makna di setiap harinya.',
                  onTap: () {
                    // TODO: Navigate to DiaryListScreen
                  },
                ),
                const SizedBox(height: 16),

                // 6. Card 2: Book your counselor (with counselor1.png)
                _FeatureCard(
                  backgroundColor: AppColors.offWhite,
                  borderColor: AppColors.lightGray,
                  title: 'Book your counselor',
                  subtitle: 'Butuh teman untuk melangkah? Jadwalkan sesi dengan konselor profesional kami.',
                  trailingImage: 'assets/images/homepage/counselor1.png',
                  onTap: () {
                    // TODO: Navigate to Booking / Counseling Screen
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: TeduhBottomNav(
        currentIndex: _selectedNavIndex,
        onTap: _onNavTapped,
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final Color backgroundColor;
  final Color borderColor;
  final String title;
  final String subtitle;
  final String? trailingImage;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.backgroundColor,
    required this.borderColor,
    required this.title,
    required this.subtitle,
    this.trailingImage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.forestGreen,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w400,
                          color: AppColors.forestGreen,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailingImage != null) ...[
                  const SizedBox(width: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      trailingImage!,
                      width: 78,
                      height: 86,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
