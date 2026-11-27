/// Model utama halaman cerita pada fitur Me & My Everyday Story.
library;

import 'diary_detail.dart';

/// Merepresentasikan satu halaman diary milik pengguna beserta daftar [details]
/// yang terhubung ke masing-masing aspek kehidupan.
class Diary {
  /// Pengenal unik halaman (`USERID + DDMMYYYY + INDEX`).
  final String diaryId;

  /// Foreign Key ID pengguna pemilik halaman diary.
  final String userId;

  /// Judul halaman cerita yang ditulis pengguna.
  final String title;

  /// Daftar relasi isi per aspek ([DiaryDetail]) yang terkunci pada halaman ini.
  final List<DiaryDetail> details;

  /// Waktu halaman diary pertama kali dibuat.
  final DateTime createdAt;

  /// Waktu terakhir halaman diary disunting.
  final DateTime updatedAt;

  /// Penanda penghapusan lunak (*soft delete*).
  final DateTime? deletedAt;

  const Diary({
    required this.diaryId,
    required this.userId,
    required this.title,
    required this.details,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  static const List<String> _shortMonths = [
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

  static const List<String> _fullMonths = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  /// Nomor hari pada bulan pembuatan halaman berdasarkan tanggal kalender lokal.
  ///
  /// Penomoran otomatis dimulai ulang dari `1` setiap pergantian bulan
  /// (misalnya tanggal 1 menjadi `1`, dan seminggu kemudian pada tanggal 8 menjadi `8`).
  int get dayNumber => createdAt.toLocal().day;

  /// Mengembalikan `true` jika halaman telah dihapus (*soft deleted*).
  bool get isDeleted => deletedAt != null;

  /// Mengembalikan `true` jika halaman masih berada pada hari yang sama
  /// (maksimal pukul 23:59 waktu lokal) sejak pertama kali dibuat.
  bool get canEdit {
    final localCreated = createdAt.toLocal();
    final now = DateTime.now();
    return localCreated.year == now.year &&
        localCreated.month == now.month &&
        localCreated.day == now.day;
  }

  /// Mengembalikan `true` jika halaman dibuat pada bulan dan tahun berjalan.
  bool get isCurrentMonth {
    final localCreated = createdAt.toLocal();
    final now = DateTime.now();
    return localCreated.year == now.year && localCreated.month == now.month;
  }

  /// Kunci pengelompokan bulan-tahun (contoh: `'2026-10'`).
  String get monthYearKey {
    final local = createdAt.toLocal();
    final month = local.month.toString().padLeft(2, '0');
    return '${local.year}-$month';
  }

  /// Label bulan dan tahun ringkas untuk chip filter arsip (contoh: `'Okt 2026'`).
  String get formattedShortMonthYear {
    final local = createdAt.toLocal();
    return '${_shortMonths[local.month - 1]}${local.year}';
  }

  /// Label bulan dan tahun lengkap (contoh: `'November 2026'`).
  String get formattedFullMonthYear {
    final local = createdAt.toLocal();
    return '${_fullMonths[local.month - 1]}${local.year}';
  }

  /// Label bulan dan tahun berjalan berdasarkan waktu lokal saat ini.
  static String get currentMonthYearLabel {
    final now = DateTime.now();
    return '${_fullMonths[now.month - 1]}${now.year}';
  }

  /// Tanggal pembuatan halaman dalam format ringkas Indonesia (contoh: `'21 Okt 2026'`).
  String get formattedCreatedDate => _formatIndoDate(createdAt.toLocal());

  /// Tanggal pembaruan terakhir dalam format ringkas Indonesia (contoh: `'24 Okt 2026'`).
  String get formattedUpdatedDate => _formatIndoDate(updatedAt.toLocal());

  static String _formatIndoDate(DateTime date) {
    return '${date.day} ${_shortMonths[date.month - 1]}${date.year}';
  }

  /// Generator ID halaman: `USERID + DDMMYYYY + 001` (contoh: `27839224112026001`).
  static String generateDiaryId({
    required String userId,
    required DateTime date,
    required int dailyIndex,
  }) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    final seq = dailyIndex.toString().padLeft(3, '0');
    return '$userId$day$month$year$seq';
  }

  /// Membuat salinan [Diary] dengan pembaruan properti tertentu.
  Diary copyWith({
    String? diaryId,
    String? userId,
    String? title,
    List<DiaryDetail>? details,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return Diary(
      diaryId: diaryId ?? this.diaryId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      details: details ?? this.details,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  /// Memetakan respons JSON API menjadi objek [Diary].
  factory Diary.fromJson(Map<String, dynamic> json) {
    final rawDetails = json['details'] as List<dynamic>? ?? [];
    return Diary(
      diaryId: json['diary_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      details: rawDetails
          .whereType<Map<String, dynamic>>()
          .map(DiaryDetail.fromJson)
          .toList(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'].toString())
          : DateTime.now(),
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'].toString())
          : null,
    );
  }

  /// Mengonversi objek [Diary] beserta daftar [details] menjadi format JSON.
  Map<String, dynamic> toJson() {
    return {
      'diary_id': diaryId,
      'user_id': userId,
      'title': title,
      'details': details.map((d) => d.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
