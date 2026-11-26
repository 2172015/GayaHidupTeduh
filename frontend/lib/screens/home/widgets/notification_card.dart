/// Banner notifikasi dapat-diperluas (*expandable*) untuk halaman beranda.
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_theme.dart';
import '../../../models/app_notification.dart';
import '../../../widgets/cards/default_card.dart';

/// Kartu pemberitahuan terpadu pada [HomeScreen] yang mewarisi [DefaultCard].
///
/// Menampilkan maksimal [maxPreviewItems] notifikasi belum dibaca ketika
/// ikon panah ditekan, serta menyediakan tautan **"Lihat Semua Notifikasi"**
/// untuk membuka halaman daftar notifikasi lengkap.
class NotificationCard extends StatefulWidget {
  /// Menentukan apakah banner ditampilkan (`true`) atau disembunyikan (`false`).
  final bool isActive;

  /// Menentukan apakah banner dapat diinteraksikan (`true`) atau nonaktif (`false`).
  final bool isEnabled;

  /// Daftar notifikasi belum dibaca yang akan diringkas.
  final List<AppNotification> unreadNotifications;

  /// Batas maksimal item notifikasi yang ditampilkan di dalam banner (default: `3`).
  final int maxPreviewItems;

  /// Callback ketika salah satu item notifikasi di dalam banner diketuk.
  final ValueChanged<AppNotification> onNotificationTap;

  /// Callback ketika tombol **"Lihat Semua Notifikasi"** diketuk.
  final VoidCallback onSeeAllPressed;

  const NotificationCard({
    super.key,
    this.isActive = true,
    this.isEnabled = true,
    required this.unreadNotifications,
    this.maxPreviewItems = 3,
    required this.onNotificationTap,
    required this.onSeeAllPressed,
  });

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  bool _isExpanded = false;

  void _toggleExpand() {
    if (!widget.isEnabled) return;
    setState(() => _isExpanded = !_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    final totalUnread = widget.unreadNotifications.length;
    if (!widget.isActive || totalUnread == 0) {
      return const SizedBox.shrink();
    }

    final previewItems = widget.unreadNotifications
        .take(widget.maxPreviewItems)
        .toList();

    return DefaultCard(
      isActive: widget.isActive,
      isEnabled: widget.isEnabled,
      backgroundColor: AppColors.sageGreen,
      hasBorder: false,
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Banner (klik kartu atau panah untuk expand/collapse)
          InkWell(
            onTap: widget.isEnabled ? _toggleExpand : null,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.forestGreen.withValues(alpha: 0.14),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications_active_rounded,
                      color: AppColors.forestGreen,
                      size: 23,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notifikasi',
                          style: AppTextTheme.cardTitle(fontSize: 15.5),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Ada $totalUnread pemberitahuan baru untukmu.',
                          style: AppTextTheme.cardSubtitle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: widget.isEnabled ? _toggleExpand : null,
                    tooltip: _isExpanded ? 'Tutup' : 'Lihat ringkasan',
                    icon: AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 220),
                      child: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.forestGreen,
                        size: 26,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Daftar Ringkas Maksimal 3 Item + Tombol "Lihat Semua Notifikasi"
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                children: [
                  ...previewItems.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: DefaultCard(
                        backgroundColor: AppColors.offWhite,
                        borderRadius: 14,
                        hasShadow: false,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        onTap: () => widget.onNotificationTap(item),
                        leading: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: item.category.badgeBackground,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            item.category.icon,
                            size: 18,
                            color: item.category.accentColor,
                          ),
                        ),
                        title: item.title,
                        titleStyle: AppTextTheme.cardTitle(fontSize: 13),
                        titleMaxLines: 1,
                        subtitle: item.message,
                        subtitleStyle: AppTextTheme.cardSubtitle(fontSize: 12),
                        subtitleMaxLines: 2,
                        trailing: Text(
                          item.formattedTime,
                          style: const TextStyle(
                            fontSize: 10.5,
                            color: AppColors.mutedText,
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 2),
                  SizedBox(
                    width: double.infinity,
                    height: 38,
                    child: OutlinedButton(
                      onPressed: widget.isEnabled
                          ? widget.onSeeAllPressed
                          : null,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.pureWhite,
                        foregroundColor: AppColors.forestGreen,
                        side: const BorderSide(
                          color: AppColors.forestGreen,
                          width: 1.2,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Lihat Semua Notifikasi',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.forestGreen,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 240),
          ),
        ],
      ),
    );
  }
}
