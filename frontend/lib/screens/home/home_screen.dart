import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/navigation/app_navigator.dart';
import '../../models/mail_thread.dart';
import '../../services/mailbox_service.dart';
import '../../services/mood_service.dart';
import '../../widgets/cards/teduh_cards.dart';
import '../../widgets/navigation/bottom_navigation_bar.dart';
import '../mailbox/mail_thread_screen.dart';
import 'widgets/animated_banner.dart';
import 'widgets/expandable_mail_banner.dart';
import 'widgets/home_header.dart';
import 'widgets/tree_of_life_widget.dart';

class HomeScreen extends StatefulWidget {
  final String fullname;
  final MoodService? moodService;
  final MailboxService? mailboxService;

  const HomeScreen({
    super.key,
    this.fullname = 'User',
    this.moodService,
    this.mailboxService,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final MoodService _moodService;
  late final MailboxService _mailboxService;

  int _streakDays = 30;
  List<MailThread> _unreadThreads = [];

  final List<Map<String, String>> _upcomingReminders = [
    {'counselor': 'Konselor Rina', 'schedule': 'Hari ini, 02:30 PM'},
    {'counselor': 'Konselor Dimas', 'schedule': 'Kamis, 26 Nov • 10:00 AM'},
  ];

  @override
  void initState() {
    super.initState();
    _moodService = widget.moodService ?? MockMoodService();
    _mailboxService = widget.mailboxService ?? MockMailboxService();
    AppNavigator.setActiveUser(fullname: widget.fullname);
    _refreshHomeData();
  }

  Future<void> _refreshHomeData() async {
    final streak = await _moodService.getCurrentStreak(
      AppNavigator.currentUserId,
    );
    final unread = await _mailboxService.getAllUnreadThreads();
    if (!mounted) return;
    setState(() {
      _streakDays = streak;
      _unreadThreads = unread;
    });
  }

  Future<void> _openUnreadMail(MailThread thread) async {
    await _mailboxService.markThreadAsRead(thread.id);
    if (!mounted) return;

    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => MailThreadScreen(
          thread: thread.copyWith(isUnread: false),
          mailboxService: _mailboxService,
        ),
      ),
    );
    await _refreshHomeData();
  }

  Future<void> _openMoodCheckIn() async {
    final savedRecord = await AppNavigator.toMoodTracker(context);
    if (savedRecord != null) {
      await _refreshHomeData();
    }
  }

  Future<void> _openMoodHistory() async {
    await AppNavigator.toMoodHistory(context);
    await _refreshHomeData();
  }

  @override
  Widget build(BuildContext context) {
    final reminderCount = _upcomingReminders.length;

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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                HomeHeader(username: widget.fullname),
                const SizedBox(height: 20),

                if (_unreadThreads.isNotEmpty) ...[
                  AnimatedBanner(
                    child: ExpandableMailBanner(
                      unreadThreads: _unreadThreads,
                      onThreadSelected: _openUnreadMail,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                if (reminderCount > 0) ...[
                  AnimatedBanner(
                    delayMs: 120,
                    child: NotificationCard.reminder(
                      title: reminderCount > 1
                          ? 'Jadwal Konseling ($reminderCount)'
                          : 'Jadwal Konseling',
                      subtitle: reminderCount > 1
                          ? '${_upcomingReminders.first['schedule']} (+${reminderCount - 1} lainnya)'
                          : _upcomingReminders.first['schedule']!,
                      onActionPressed: () => AppNavigator.toCounseling(context),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                TreeOfLifeWidget(
                  streakDays: _streakDays,
                  onTap: _openMoodCheckIn,
                ),
                const SizedBox(height: 18),

                ElevatedButton(
                  onPressed: _openMoodHistory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.sageGreen,
                    foregroundColor: AppColors.forestGreen,
                    elevation: 3,
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
                const SizedBox(height: 26),

                FeatureCard(
                  backgroundColor: AppColors.sageGreen,
                  title: 'Me & My Everyday Story',
                  subtitle: 'Ruang aman untuk ceritamu. Tuangkan pikiran dan temukan makna di setiap harinya.',
                  onTap: () => AppNavigator.toDiary(context),
                ),
                const SizedBox(height: 16),

                FeatureCard(
                  backgroundColor: AppColors.offWhite,
                  title: 'Book your counselor',
                  subtitle: 'Butuh teman untuk melangkah? Jadwalkan sesi dengan konselor profesional kami.',
                  imageAssetPath: 'assets/images/homepage/counselor1.png',
                  onTap: () => AppNavigator.toBookSession(context),
                ),
                const SizedBox(height: 16),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.errorBackground,
                    foregroundColor: AppColors.errorRed,
                  ),
                  onPressed: () => AppNavigator.toLogin(context),
                  child: const Text('Logout'),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: TeduhBottomNav(
        currentIndex: 0,
        onTap: (index) => AppNavigator.onBottomNavTapped(
          context,
          currentIndex: 0,
          targetIndex: index,
        ),
      ),
    );
  }
}
