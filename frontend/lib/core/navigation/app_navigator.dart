import 'package:flutter/material.dart';
import 'package:gaya_hidup_teduh/screens/booking/book_session_date_screen.dart';
import 'package:gaya_hidup_teduh/screens/counseling/counseling_screen.dart';
import 'package:gaya_hidup_teduh/services/counseling_service.dart';

import '../../models/mood_record.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/diary/diary_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/mood/mood_history_screen.dart';
import '../../screens/mood/mood_tracker_screen.dart';

class AppNavigator {
  AppNavigator._();

  static String _currentFullname = 'User';
  static String _currentUserId = '278392';

  static String get currentUserId => _currentUserId;
  static String get currentFullname => _currentFullname;

  static void setActiveUser({
    required String fullname,
    String userId = '278392',
  }) {
    if (fullname.trim().isNotEmpty) {
      _currentFullname = fullname.trim();
    }
    _currentUserId = userId;
  }

  /// Handler terpusat untuk TeduhBottomNav di semua halaman utama
  static void onBottomNavTapped(
    BuildContext context, {
    required int currentIndex,
    required int targetIndex,
  }) {
    if (currentIndex == targetIndex) return;

    switch (targetIndex) {
      case 0:
        toHome(context);
        break;
      case 1:
        toDiary(context);
        break;
      case 2:
        toCounseling(context);
        break;
      case 3:
        // TODO: toProfile(context);
        break;
    }
  }

  /// Navigasi Tab Utama (membersihkan stack agar highlight nav bar selalu akurat)
  static void toHome(BuildContext context, {String? fullname}) {
    if (fullname != null && fullname.trim().isNotEmpty) {
      _currentFullname = fullname.trim();
    }

    Navigator.pushAndRemoveUntil(
      context,
      _buildTabRoute(HomeScreen(fullname: _currentFullname)),
      (route) => false,
    );
  }

  static void toDiary(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      _buildTabRoute(DiaryScreen(userId: _currentUserId)),
      (route) => false,
    );
  }

  /// Navigasi Fitur Mood Tracker & Riwayat Mood
  static Future<MoodRecord?> toMoodTracker(
    BuildContext context, {
    MoodRecord? initialRecord,
  }) {
    return Navigator.push<MoodRecord>(
      context,
      MaterialPageRoute<MoodRecord>(
        builder: (_) => MoodTrackerScreen(
          userId: _currentUserId,
          initialRecord: initialRecord,
        ),
      ),
    );
  }

  static Future<void> toMoodHistory(BuildContext context) {
    return Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => MoodHistoryScreen(userId: _currentUserId),
      ),
    );
  }

  /// Navigasi Autentikasi
  static void toLogin(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  static void toRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => const RegisterScreen()),
    );
  }

  static void toCounseling(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      _buildTabRoute(CounselingScreen(userId: _currentUserId)),
      (route) => false,
    );
  }

  static Future<void> toBookSession(BuildContext context) {
    final service = MockCounselingService()..clearCart();
    return Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => BookSessionDateScreen(
          userId: _currentUserId,
          counselingService: service,
        ),
      ),
    );
  }

  static PageRouteBuilder<void> _buildTabRoute(Widget page) {
    return PageRouteBuilder<void>(
      pageBuilder: (_, _, _) => page,
      transitionDuration: const Duration(milliseconds: 160),
      reverseTransitionDuration: const Duration(milliseconds: 160),
      transitionsBuilder: (_, animation, _, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
