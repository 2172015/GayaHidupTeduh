/// Halaman daftar notifikasi lengkap untuk aplikasi Gaya Hidup Teduh.
library;

import 'package:flutter/material.dart';

import '../../core/navigation/app_navigator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_theme.dart';
import '../../models/app_notification.dart';
import '../../services/mailbox_service.dart';
import '../../services/notification_service.dart';
import '../../widgets/cards/default_card.dart';
import '../../widgets/common/teduh_confirm_dialog.dart';
import '../../widgets/common/teduh_scaffold.dart';
import '../mailbox/mail_thread_screen.dart';
import '../profile/voucher_list_screen.dart';

/// Layar riwayat dan pusat notifikasi pengguna.
class NotificationScreen extends StatefulWidget {
  /// ID pengguna aktif.
  final String userId;

  /// Layanan data notifikasi.
  final NotificationService? notificationService;

  const NotificationScreen({
    super.key,
    required this.userId,
    this.notificationService,
  });

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late final NotificationService _notificationService;
  final MailboxService _mailboxService = MockMailboxService();

  List<AppNotification> _notifications = [];
  NotificationCategory? _selectedCategory;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _notificationService =
        widget.notificationService ?? MockNotificationService();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    final items = await _notificationService.getNotifications(widget.userId);
    if (!mounted) return;
    setState(() {
      _notifications = items;
      _isLoading = false;
    });
  }

  Future<void> _markAllRead() async {
    await _notificationService.markAllAsRead(widget.userId);
    await _loadNotifications();
  }

  Future<void> _deleteSingleNotification(AppNotification item) async {
    await _notificationService.deleteNotification(item.id);
    await _loadNotifications();
  }

  Future<void> _confirmDeleteAllRead() async {
    final confirmed = await TeduhConfirmDialog.show(
      context,
      title: 'Hapus Notifikasi Dibaca?',
      message: 'Semua notifikasi yang sudah dibaca akan dihapus secara permanen dari daftar.',
      confirmLabel: 'Hapus',
      isDestructive: true,
    );
    if (!confirmed) return;

    await _notificationService.deleteAllRead(widget.userId);
    await _loadNotifications();
  }

  Future<void> _handleNotificationTap(AppNotification item) async {
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
            builder: (_) => VoucherListScreen(userId: widget.userId),
          ),
        );
        break;
      case NotificationCategory.streak:
        await AppNavigator.toMoodHistory(context);
        break;
    }

    await _loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final hasUnread = _notifications.any((n) => !n.isRead);
    final hasRead = _notifications.any((n) => n.isRead);
    final filtered = _selectedCategory == null
        ? _notifications
        : _notifications.where((n) => n.category == _selectedCategory).toList();

    return TeduhScaffold(
      title: 'Notifikasi',
      appBarActions: [
        if (hasUnread)
          IconButton(
            tooltip: 'Tandai Semua Dibaca',
            icon: const Icon(
              Icons.done_all_rounded,
              color: AppColors.forestGreen,
              size: 22,
            ),
            onPressed: _markAllRead,
          ),
        if (hasRead)
          IconButton(
            tooltip: 'Hapus yang Sudah Dibaca',
            icon: const Icon(
              Icons.delete_sweep_outlined,
              color: AppColors.errorRed,
              size: 22,
            ),
            onPressed: _confirmDeleteAllRead,
          ),
      ],
      body: Column(
        children: [
          // Filter Kategori Horizontal
          SizedBox(
            height: 46,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
              children: [
                _buildFilterChip(label: 'Semua', category: null),
                const SizedBox(width: 8),
                ...NotificationCategory.values.map((cat) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildFilterChip(label: cat.label, category: cat),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Daftar Notifikasi
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.forestGreen,
                    ),
                  )
                : filtered.isEmpty
                ? Center(
                    child: Text(
                      'Belum ada notifikasi pada kategori ini.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(24, 6, 24, 24),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return DefaultCard(
                        backgroundColor: item.isRead
                            ? AppColors.offWhite
                            : AppColors.pureWhite,
                        padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
                        onTap: () => _handleNotificationTap(item),
                        leading: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: item.category.badgeBackground,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            item.category.icon,
                            color: item.category.accentColor,
                            size: 22,
                          ),
                        ),
                        title: item.title,
                        titleStyle: AppTextTheme.cardTitle(fontSize: 14.5),
                        subtitle: item.message,
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () => _deleteSingleNotification(item),
                              borderRadius: BorderRadius.circular(12),
                              child: const Padding(
                                padding: EdgeInsets.all(2),
                                child: Icon(
                                  Icons.close_rounded,
                                  size: 18,
                                  color: AppColors.mutedText,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!item.isRead) ...[
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.sageGreen,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                ],
                                Text(
                                  item.formattedTime,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.mutedText,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required NotificationCategory? category,
  }) {
    final isSelected = _selectedCategory == category;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => setState(() => _selectedCategory = category),
      selectedColor: AppColors.forestGreen,
      backgroundColor: AppColors.pureWhite,
      showCheckmark: false,
      labelStyle: TextStyle(
        fontSize: 12.5,
        fontWeight: FontWeight.w600,
        color: isSelected ? AppColors.pureWhite : AppColors.forestGreen,
      ),
      side: BorderSide(color: AppColors.forestGreen.withValues(alpha: 0.35)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
