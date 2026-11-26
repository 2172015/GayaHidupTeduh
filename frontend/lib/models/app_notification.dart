/// Model data notifikasi terpadu untuk aplikasi Gaya Hidup Teduh.
library;

import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// Kategori pemberitahuan yang diterima pengguna di dalam aplikasi.
enum NotificationCategory {
  /// Pesan atau balasan baru dari konselor di Mailbox.
  mail(
    label: 'Pesan Konselor',
    icon: Icons.mark_email_unread_rounded,
    accentColor: AppColors.forestGreen,
    badgeBackground: Color(0xFFDCEAD1),
  ),

  /// Pengingat jadwal sesi konseling yang akan datang.
  counseling(
    label: 'Jadwal Konseling',
    icon: Icons.event_available_rounded,
    accentColor: AppColors.forestGreen,
    badgeBackground: Color(0xFFE9D8A6),
  ),

  /// Pencapaian atau pengingat harian Pohon Kehidupan (Mood Tracker).
  streak(
    label: 'Pohon Kehidupan',
    icon: Icons.local_fire_department_rounded,
    accentColor: AppColors.lightForestGreen,
    badgeBackground: Color(0xFFDCEAD1),
  ),

  /// Pemberitahuan voucher potongan konseling baru.
  voucher(
    label: 'Voucher Baru',
    icon: Icons.confirmation_number_rounded,
    accentColor: Color(0xFF9C7A3C),
    badgeBackground: Color(0xFFE9D8A6),
  );

  /// Nama kategori yang tampil pada chip filter dan label.
  final String label;

  /// Ikon perwakilan kategori notifikasi.
  final IconData icon;

  /// Warna utama ikon dan teks kategori.
  final Color accentColor;

  /// Warna latar lembut untuk wadah ikon kategori.
  final Color badgeBackground;

  const NotificationCategory({
    required this.label,
    required this.icon,
    required this.accentColor,
    required this.badgeBackground,
  });
}

/// Representasi satu item pemberitahuan untuk ditampilkan pada banner beranda
/// maupun halaman daftar notifikasi lengkap.
class AppNotification {
  /// ID unik notifikasi.
  final String id;

  /// Kategori notifikasi ([NotificationCategory]).
  final NotificationCategory category;

  /// Judul singkat pemberitahuan.
  final String title;

  /// Ringkasan isi pemberitahuan.
  final String message;

  /// Waktu pemberitahuan dibuat.
  final DateTime createdAt;

  /// Status apakah notifikasi sudah dibaca oleh pengguna.
  final bool isRead;

  /// ID referensi opsional (misalnya ID thread mail atau ID voucher) untuk navigasi langsung.
  final String? referenceId;

  const AppNotification({
    required this.id,
    required this.category,
    required this.title,
    required this.message,
    required this.createdAt,
    this.isRead = false,
    this.referenceId,
  });

  /// Format waktu ringkas untuk ditampilkan pada kartu notifikasi.
  String get formattedTime {
    final now = DateTime.now();
    final isToday =
        createdAt.year == now.year &&
        createdAt.month == now.month &&
        createdAt.day == now.day;

    if (isToday) {
      final hour12 = createdAt.hour == 0
          ? 12
          : (createdAt.hour > 12 ? createdAt.hour - 12 : createdAt.hour);
      final minute = createdAt.minute.toString().padLeft(2, '0');
      final period = createdAt.hour >= 12 ? 'PM' : 'AM';
      return '${hour12.toString().padLeft(2, '0')}:$minute $period';
    }

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${createdAt.day} ${months[createdAt.month - 1]}';
  }

  /// Mengembalikan salinan [AppNotification] dengan pembaruan properti tertentu.
  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      category: category,
      title: title,
      message: message,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
      referenceId: referenceId,
    );
  }
}
