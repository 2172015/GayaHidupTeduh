import 'package:flutter/material.dart';
import 'package:gaya_hidup_teduh/screens/home/home_screen.dart';
import 'package:gaya_hidup_teduh/widgets/bottom_navigation_bar.dart';

import '../../core/app_colors.dart';

class DiaryScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  int _selectedNavIndex = 1;

  void _onNavTapped(int index) {
    setState(() {
      _selectedNavIndex = index;
      if (index == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else if (index == 1) {
        //
      } else if (index == 2) {
        // Navigate to Counseling
      } else if (index == 3) {
        // Navigate to Profile
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
        child: Center(child: Text('Hello, World!')),
      ),
      bottomNavigationBar: TeduhBottomNav(
        currentIndex: _selectedNavIndex,
        onTap: _onNavTapped,
      ),
    );
  }
}
