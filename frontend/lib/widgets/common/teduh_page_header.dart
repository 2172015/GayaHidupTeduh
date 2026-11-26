/// Komponen header standar untuk halaman tab utama aplikasi Gaya Hidup Teduh.
library;

import 'package:flutter/material.dart';

import '../../core/navigation/app_navigator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_theme.dart';

/// Header standar untuk layar utama (*Home, Diary, Counseling, Profile*)
/// yang memanfaatkan tipografi dari [AppTextTheme] dan [ThemeData.textTheme].
///
/// Properti [showNotificationButton] dan [showProfilePicture] bernilai `false`
/// secara default dan diaktifkan pada halaman beranda ([HomeScreen]).
class TeduhPageHeader extends StatelessWidget {
  /// Menentukan apakah header ditampilkan (`true`) atau disembunyikan (`false`).
  final bool isActive;

  /// Teks merek kecil di bagian paling atas (default: `'Gaya Hidup Teduh'`).
  final String eyebrow;

  /// Judul utama halaman.
  final String title;

  /// Subjudul pengantar opsional di bawah [title].
  final String? subtitle;

  /// Menampilkan tombol ikon lonceng notifikasi di kanan atas jika bernilai `true`.
  final bool showNotificationButton;

  /// Jumlah notifikasi belum dibaca; menampilkan titik indikator jika `> 0`.
  final int unreadNotificationCount;

  /// Aksi saat tombol ikon notifikasi diketuk.
  final VoidCallback? onNotificationTap;

  /// Menampilkan foto profil melingkar di sisi kanan atas jika bernilai `true`.
  final bool showProfilePicture;

  /// Path aset foto profil yang ditampilkan saat [showProfilePicture] bernilai `true`.
  final String avatarAsset;

  /// Aksi saat foto profil diketuk (default mengarah ke [AppNavigator.toProfile]).
  final VoidCallback? onProfileTap;

  const TeduhPageHeader({
    super.key,
    this.isActive = true,
    this.eyebrow = 'Gaya Hidup Teduh',
    required this.title,
    this.subtitle,
    this.showNotificationButton = false,
    this.unreadNotificationCount = 0,
    this.onNotificationTap,
    this.showProfilePicture = false,
    this.avatarAsset = 'assets/images/profilepicture/male_1.jpg',
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    if (!isActive) return const SizedBox.shrink();

    final textTheme = Theme.of(context).textTheme;
    final hasRightActions = showNotificationButton || showProfilePicture;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(eyebrow, style: AppTextTheme.brandEyebrow),
              const SizedBox(height: 8),
              Text(title, style: textTheme.displaySmall),
              if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(subtitle!, style: textTheme.titleSmall),
              ],
            ],
          ),
        ),
        if (hasRightActions) ...[
          const SizedBox(width: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (showNotificationButton) _buildNotificationButton(),
              if (showNotificationButton && showProfilePicture)
                const SizedBox(width: 6),
              if (showProfilePicture) _buildProfileAvatar(context),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildNotificationButton() {
    final hasUnread = unreadNotificationCount > 0;

    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onNotificationTap,
        splashColor: AppColors.sageGreen.withValues(alpha: 0.25),
        highlightColor: AppColors.sageGreen.withValues(alpha: 0.12),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                hasUnread
                    ? Icons.notifications_active_outlined
                    : Icons.notifications_none_rounded,
                color: AppColors.forestGreen,
                size: 26,
              ),
              if (hasUnread)
                Positioned(
                  top: 9,
                  right: 10,
                  child: Container(
                    width: 9.5,
                    height: 9.5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.errorRed,
                      border: Border.all(color: AppColors.offWhite, width: 1.5),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(BuildContext context) {
    return GestureDetector(
      onTap: onProfileTap ?? () => AppNavigator.toProfile(context),
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.sageGreen.withValues(alpha: 0.35),
          border: Border.all(
            color: AppColors.forestGreen.withValues(alpha: 0.35),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipOval(
          child: Image.asset(
            avatarAsset,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => const Icon(
              Icons.person_rounded,
              color: AppColors.forestGreen,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
