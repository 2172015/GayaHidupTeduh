import 'package:flutter/material.dart';
import 'package:gaya_hidup_teduh/screens/auth/login_screen.dart';
import 'package:gaya_hidup_teduh/screens/diary/diary_screen.dart';

import '../../core/app_colors.dart';
import '../../widgets/bottom_navigation_bar.dart';
import '../../widgets/feature_card.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({super.key, this.username = 'User'});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNavIndex = 0;
  int _streakDays = 30;

  void _onNavTapped(int index) {
    setState(() {
      _selectedNavIndex = index;
      if (index == 0) {
        //
      } else if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DiaryScreen()),
        );
      } else if (index == 2) {
        // Navigate to Counseling
      } else if (index == 3) {
        // Navigate to Profile
      }
    });
  }

  void _onStreakTapped() {
    setState(() {
      if (_streakDays < 7) {
        _streakDays = 7;
      } else if (_streakDays < 14) {
        _streakDays = 14;
      } else if (_streakDays < 21) {
        _streakDays = 21;
      } else {
        _streakDays = 0;
      }
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

                const Text(
                  'Pohon Kehidupan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.forestGreen,
                  ),
                ),
                const SizedBox(height: 12),

                GestureDetector(
                  onTap: _onStreakTapped,
                  child: Container(
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 240,
                          height: 240,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.forestGreen,
                            border: Border.all(
                              color: Color(0XFFB2C0A6),
                              width: 5,
                            ),
                          ),
                        ),

                        Positioned(
                          bottom: 35,
                          child: Image.asset(
                            _streakDays < 7
                                ? 'assets/images/homepage/Streak1-png.png'
                                : _streakDays < 14
                                ? 'assets/images/homepage/Streak2-png.png'
                                : _streakDays < 21
                                ? 'assets/images/homepage/Streak3-png.png'
                                : 'assets/images/homepage/Streak4-png.png',
                            width: 230,
                            height: 230,
                            fit: BoxFit.contain,
                          ),
                        ),

                        Positioned(
                          bottom: 30,
                          child: Column(
                            children: [
                              Row(
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
                              Text(
                                "Ketuk untuk Check-In",
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: AppColors.pureWhite,
                                      fontSize: 11,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
                      // Ke Mood Tracker
                      _onStreakTapped();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.sageGreen,
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

                FeatureCard(
                  backgroundColor: AppColors.sageGreen,
                  borderColor: AppColors.lightForestGreen.withValues(
                    alpha: 0.4,
                  ),
                  title: 'Me & My Everyday Story',
                  subtitle: 'Ruang aman untuk ceritamu. Tuangkan pikiran dan temukan makna di setiap harinya.',
                  onTap: () {
                    // Ke Diary
                  },
                ),
                const SizedBox(height: 16),

                FeatureCard(
                  backgroundColor: AppColors.offWhite,
                  borderColor: AppColors.lightGray,
                  title: 'Book your counselor',
                  subtitle: 'Butuh teman untuk melangkah? Jadwalkan sesi dengan konselor profesional kami.',
                  trailingImage: 'assets/images/homepage/counselor1.png',
                  onTap: () {
                    // Ke Counseling
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.errorBackground,
                    foregroundColor: AppColors.errorRed,
                  ),
                  onPressed: () {
                    // Navigator.of(context).pushAndRemoveUntil(
                    //   MaterialPageRoute(builder: (_) => const LoginScreen()),
                    //   (route) => false,
                    // );
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  child: const Text(
                    "Logout",
                    style: TextStyle(color: AppColors.errorRed),
                  ),
                ),
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
