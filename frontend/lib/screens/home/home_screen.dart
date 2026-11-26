/// Halaman beranda utama aplikasi Gaya Hidup Teduh.
library;

import 'package:flutter/material.dart';

import '../../core/navigation/app_navigator.dart';
import '../../core/theme/app_colors.dart';
import '../../models/app_notification.dart';
import '../../services/mailbox_service.dart';
import '../../services/mood_service.dart';
import '../../services/notification_service.dart';
import '../../services/profile_service.dart';
import '../../widgets/common/teduh_page_header.dart';
import '../../widgets/common/teduh_scaffold.dart';
import '../../widgets/navigation/bottom_navigation_bar.dart';
import '../mailbox/mail_thread_screen.dart';
import '../profile/voucher_list_screen.dart';
import 'notification_screen.dart';
import 'widgets/animated_banner.dart';
import 'widgets/feature_card.dart';
import 'widgets/notification_card.dart';
import 'widgets/tree_of_life_widget.dart';

class HomeScreen extends StatefulWidget {
  final String fullname;
  final MoodService? moodService;
  final NotificationService? notificationService;
  final ProfileService? profileService;

  const HomeScreen({
    super.key,
    this.fullname = 'User',
    this.moodService,
    this.notificationService,
    this.profileService,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final MoodService _moodService;
  late final NotificationService _notificationService;
  late final ProfileService _profileService;
  final MailboxService _mailboxService = MockMailboxService();

  int _streakDays = 30;
  String _avatarAsset = 'assets/images/profilepicture/male_1.jpg';
  List<AppNotification> _unreadNotifications = [];

  @override
  void initState() {
    super.initState();
    _moodService = widget.moodService ?? MockMoodService();
    _notificationService =
        widget.notificationService ?? MockNotificationService();
    _profileService = widget.profileService ?? MockProfileService();
    AppNavigator.setActiveUser(fullname: widget.fullname);
    _refreshHomeData();
  }

  Future<void> _refreshHomeData() async {
    final userId = AppNavigator.currentUserId;
    final streak = await _moodService.getCurrentStreak(userId);
    final unread = await _notificationService.getUnreadNotifications(userId);
    final profile = await _profileService.getProfile(userId);
    if (!mounted) return;
    setState(() {
      _streakDays = streak;
      _unreadNotifications = unread;
      _avatarAsset = profile.avatarAsset;
    });
  }

  Future<void> _openNotificationScreen() async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => NotificationScreen(
          userId: AppNavigator.currentUserId,
          notificationService: _notificationService,
        ),
      ),
    );
    await _refreshHomeData();
  }

  Future<void> _handleBannerNotificationTap(AppNotification item) async {
    await _notificationService.markAsRead(item.id);
    if (!mounted) return;

    switch (item.category) {
      case NotificationCategory.mail:
        final unreadThreads = await _mailboxService.getAllUnreadThreads();
        final matched = unreadThreads
            .where((t) => t.id == item.referenceId)
            .firstOrNull;
        if (!mounted) return;
        if (matched != null) {
          await _mailboxService.markThreadAsRead(matched.id);
          if (!mounted) return;
          await Navigator.push<void>(
            context,
            MaterialPageRoute<void>(
              builder: (_) => MailThreadScreen(
                thread: matched.copyWith(isUnread: false),
                mailboxService: _mailboxService,
              ),
            ),
          );
        } else {
          AppNavigator.toCounseling(context);
          return;
        }
        break;
      case NotificationCategory.counseling:
        AppNavigator.toCounseling(context);
        return;
      case NotificationCategory.voucher:
        await Navigator.push<void>(
          context,
          MaterialPageRoute<void>(
            builder: (_) =>
                VoucherListScreen(userId: AppNavigator.currentUserId),
          ),
        );
        break;
      case NotificationCategory.streak:
        await AppNavigator.toMoodHistory(context);
        break;
    }

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
    return TeduhScaffold(
      bottomNavigationBar: TeduhBottomNav(
        currentIndex: 0,
        onTap: (index) => AppNavigator.onBottomNavTapped(
          context,
          currentIndex: 0,
          targetIndex: index,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            TeduhPageHeader(
              title: 'Halo, ${widget.fullname}!',
              showNotificationButton: _unreadNotifications.isEmpty,
              unreadNotificationCount: _unreadNotifications.length,
              onNotificationTap: _openNotificationScreen,
              showProfilePicture: true,
              avatarAsset: _avatarAsset,
            ),
            const SizedBox(height: 20),

            if (_unreadNotifications.isNotEmpty) ...[
              AnimatedBanner(
                child: NotificationCard(
                  unreadNotifications: _unreadNotifications,
                  onNotificationTap: _handleBannerNotificationTap,
                  onSeeAllPressed: _openNotificationScreen,
                ),
              ),
              const SizedBox(height: 20),
            ],

            TreeOfLifeWidget(streakDays: _streakDays, onTap: _openMoodCheckIn),
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
          ],
        ),
      ),
    );
  }
}
