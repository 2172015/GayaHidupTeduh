import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/navigation/app_navigator.dart';
import '../../models/counseling_session_status.dart';
import '../../models/user_profile.dart';
import '../../services/counseling_service.dart';
import '../../services/diary_service.dart';
import '../../services/mood_service.dart';
import '../../services/profile_service.dart';
import '../../services/voucher_service.dart';
import '../../widgets/common/teduh_confirm_dialog.dart';
import '../../widgets/navigation/bottom_navigation_bar.dart';
import 'about_teduh_screen.dart';
import 'change_password_screen.dart';
import 'change_username_screen.dart';
import 'edit_profile_screen.dart';
import 'settings_screen.dart';
import 'voucher_list_screen.dart';
import 'widgets/profile_header_card.dart';
import 'widgets/profile_menu_card.dart';
import 'widgets/wellness_journey_card.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  final ProfileService? profileService;
  final VoucherService? voucherService;
  final MoodService? moodService;
  final DiaryService? diaryService;
  final CounselingService? counselingService;

  const ProfileScreen({
    super.key,
    this.userId = '278392',
    this.profileService,
    this.voucherService,
    this.moodService,
    this.diaryService,
    this.counselingService,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileService _profileService;
  late final VoucherService _voucherService;
  late final MoodService _moodService;
  late final DiaryService _diaryService;
  late final CounselingService _counselingService;

  UserProfile? _profile;
  int _streakDays = 0;
  int _diaryCount = 0;
  int _checkInCount = 0;
  int _completedSessionsCount = 0;
  int _availableVoucherCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _profileService = widget.profileService ?? MockProfileService();
    _voucherService = widget.voucherService ?? MockVoucherService();
    _moodService = widget.moodService ?? MockMoodService();
    _diaryService = widget.diaryService ?? MockDiaryService();
    _counselingService = widget.counselingService ?? MockCounselingService();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    setState(() => _isLoading = true);

    final profile = await _profileService.getProfile(widget.userId);
    final streak = await _moodService.getCurrentStreak(widget.userId);
    final moodHistory = await _moodService.getHistory(widget.userId);
    final diaries = await _diaryService.getDiaries(widget.userId);
    final bookings = await _counselingService.getUserBookings(widget.userId);
    final vouchers = await _voucherService.getUserVouchers(widget.userId);

    if (!mounted) return;
    AppNavigator.setActiveUser(userId: profile.id, fullname: profile.fullName);

    setState(() {
      _profile = profile;
      _streakDays = streak;
      _checkInCount = moodHistory.length;
      _diaryCount = diaries.length;
      _completedSessionsCount = bookings
          .where((b) => b.status == CounselingSessionStatus.completed)
          .length;
      _availableVoucherCount = vouchers.where((v) => v.isAvailable).length;
      _isLoading = false;
    });
  }

  Future<void> _openEditProfile() async {
    if (_profile == null) return;
    final updated = await Navigator.push<UserProfile>(
      context,
      MaterialPageRoute<UserProfile>(
        builder: (_) => EditProfileScreen(
          profile: _profile!,
          profileService: _profileService,
        ),
      ),
    );
    if (updated != null) {
      await _loadProfileData();
    }
  }

  Future<void> _openVouchers() async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => VoucherListScreen(
          userId: widget.userId,
          voucherService: _voucherService,
        ),
      ),
    );
    await _loadProfileData();
  }

  Future<void> _openChangeUsername() async {
    if (_profile == null) return;
    final updated = await Navigator.push<UserProfile>(
      context,
      MaterialPageRoute<UserProfile>(
        builder: (_) => ChangeUsernameScreen(
          profile: _profile!,
          profileService: _profileService,
        ),
      ),
    );
    if (updated != null) {
      await _loadProfileData();
    }
  }

  Future<void> _confirmLogout() async {
    final confirmed = await TeduhConfirmDialog.show(
      context,
      title: 'Keluar dari Akun?',
      message: 'Kamu akan keluar dari sesi Gaya Hidup Teduh saat ini dan perlu masuk kembali.',
      confirmLabel: 'Logout',
      isDestructive: true,
    );
    if (confirmed && mounted) {
      AppNavigator.toLogin(context);
    }
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
          child: _isLoading || _profile == null
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.forestGreen,
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Gaya Hidup Teduh',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF7D9378),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.forestGreen,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Kartu Identitas Utama
                      ProfileHeaderCard(
                        profile: _profile!,
                        onEditPressed: _openEditProfile,
                      ),
                      const SizedBox(height: 14),

                      // Kartu Perjalanan Teduhku
                      WellnessJourneyCard(
                        streakDays: _streakDays,
                        diaryCount: _diaryCount,
                        checkInCount: _checkInCount,
                        completedSessionsCount: _completedSessionsCount,
                      ),
                      const SizedBox(height: 14),

                      // Kartu Preview Voucher Saya
                      _buildVoucherPreviewCard(),
                      const SizedBox(height: 14),

                      // Kartu Menu Pengaturan Akun
                      ProfileMenuCard(
                        items: [
                          ProfileMenuItemData(
                            title: 'Ubah Username',
                            onTap: _openChangeUsername,
                          ),
                          ProfileMenuItemData(
                            title: 'Ubah Kata Sandi',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (_) => ChangePasswordScreen(
                                    userId: widget.userId,
                                    profileService: _profileService,
                                  ),
                                ),
                              );
                            },
                          ),
                          ProfileMenuItemData(
                            title: 'Pengaturan',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (_) => SettingsScreen(
                                    userId: widget.userId,
                                    profileService: _profileService,
                                  ),
                                ),
                              );
                            },
                          ),
                          ProfileMenuItemData(
                            title: 'Tentang Gaya Hidup Teduh',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (_) => const AboutTeduhScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Tombol Logout
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton(
                          onPressed: _confirmLogout,
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(0xFFF8BDBD),
                            foregroundColor: AppColors.errorRed,
                            side: const BorderSide(
                              color: AppColors.errorRed,
                              width: 1.4,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.errorRed,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
      bottomNavigationBar: TeduhBottomNav(
        currentIndex: 3,
        onTap: (index) => AppNavigator.onBottomNavTapped(
          context,
          currentIndex: 3,
          targetIndex: index,
        ),
      ),
    );
  }

  Widget _buildVoucherPreviewCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: _openVouchers,
          splashColor: AppColors.sageGreen.withValues(alpha: 0.2),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9D8A6).withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.confirmation_number_rounded,
                    color: Color(0xFF9C7A3C),
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Voucher Saya',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E1E1E),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$_availableVoucherCount voucher tersedia',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF7A7E75),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 22,
                  color: AppColors.forestGreen,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
