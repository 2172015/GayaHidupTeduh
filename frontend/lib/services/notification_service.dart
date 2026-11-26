/// Kontrak dan implementasi mock untuk pengelolaan notifikasi pengguna.
library;

import '../models/app_notification.dart';

/// Kontrak layanan pengambilan, pembaruan status, dan penghapusan notifikasi.
abstract class NotificationService {
  /// Mengambil seluruh daftar notifikasi milik [userId] diurutkan dari yang terbaru.
  Future<List<AppNotification>> getNotifications(String userId);

  /// Mengambil daftar notifikasi yang belum dibaca milik [userId].
  Future<List<AppNotification>> getUnreadNotifications(String userId);

  /// Menandai satu notifikasi sebagai sudah dibaca.
  Future<void> markAsRead(String notificationId);

  /// Menandai seluruh notifikasi milik [userId] sebagai sudah dibaca.
  Future<void> markAllAsRead(String userId);

  /// Menghapus satu notifikasi berdasarkan [notificationId].
  Future<void> deleteNotification(String notificationId);

  /// Menghapus seluruh notifikasi yang berstatus sudah dibaca milik [userId].
  Future<void> deleteAllRead(String userId);
}

/// Implementasi mock [NotificationService] yang menggabungkan notifikasi
/// pesan konselor, jadwal sesi, streak pohon kehidupan, dan voucher baru.
class MockNotificationService implements NotificationService {
  static final List<AppNotification> _notifications = [
    AppNotification(
      id: 'notif-1',
      category: NotificationCategory.mail,
      title: 'Pesan Baru dari Clara Elson, Psikolog',
      message: 'Subjek: Weekly reflection checklist — "I\'ve completed the mindfulness reflection we discussed..."',
      createdAt: DateTime.now().subtract(const Duration(minutes: 25)),
      isRead: false,
      referenceId: 'mail-1',
    ),
    AppNotification(
      id: 'notif-2',
      category: NotificationCategory.counseling,
      title: 'Jadwal Konseling Hari Ini',
      message: 'Sesi konseling onlinemu bersama Clara Elson, Psikolog dimulai pukul 02:30 PM.',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
    ),
    AppNotification(
      id: 'notif-3',
      category: NotificationCategory.voucher,
      title: 'Voucher Apresiasi 30% Tersedia!',
      message: 'Selamat! Kamu mendapatkan kode TEDUHSTREAK30 untuk potongan sesi konseling berikutnya.',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: false,
      referenceId: 'v1',
    ),
    AppNotification(
      id: 'notif-4',
      category: NotificationCategory.streak,
      title: '30 Hari Streak Tercapai!',
      message: 'Pohon Kehidupanmu kini mencapai tahap bercahaya. Jaga ritme check-in harianmu!',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: false,
    ),
    AppNotification(
      id: 'notif-5',
      category: NotificationCategory.mail,
      title: 'Pesan dari Clara Elson, Psikolog',
      message: 'Subjek: Next Session Preparation — Silakan hubungi jika ada topik khusus yang ingin dibahas.',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
      referenceId: 'mail-2',
    ),
  ];

  @override
  Future<List<AppNotification>> getNotifications(String userId) async {
    await Future.delayed(const Duration(milliseconds: 180));
    final sorted = List<AppNotification>.from(_notifications)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted;
  }

  @override
  Future<List<AppNotification>> getUnreadNotifications(String userId) async {
    final all = await getNotifications(userId);
    return all.where((n) => !n.isRead).toList();
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    for (int i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isRead) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
    }
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    _notifications.removeWhere((n) => n.id == notificationId);
  }

  @override
  Future<void> deleteAllRead(String userId) async {
    _notifications.removeWhere((n) => n.isRead);
  }
}
