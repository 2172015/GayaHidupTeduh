/// Model relasional yang menyimpan isi refleksi pengguna per aspek diary.
library;

import 'diary_aspect.dart';

/// Entitas penghubung (*junction model*) antara [Diary] dan [DiaryAspect].
///
/// Mengunci referensi [aspect] pada saat halaman dibuat sehingga riwayat
/// diary lama tetap dapat dibaca secara utuh meskipun daftar aspek aktif
/// berubah di kemudian hari.
class DiaryDetail {
  /// Pengenal unik baris detail (Primary Key).
  final String detailId;

  /// Foreign Key yang merujuk ke [Diary.diaryId].
  final String diaryId;

  /// Foreign Key yang merujuk ke [DiaryAspect.aspectId].
  final String aspectId;

  /// Snapshot metadata [DiaryAspect] yang melekat pada entri ini.
  final DiaryAspect aspect;

  /// Isi cerita atau refleksi yang ditulis pengguna (boleh kosong/`null`).
  final String? content;

  /// Waktu terakhir konten aspek ini diperbarui.
  final DateTime updatedAt;

  const DiaryDetail({
    required this.detailId,
    required this.diaryId,
    required this.aspectId,
    required this.aspect,
    this.content,
    required this.updatedAt,
  });

  /// Mengembalikan `true` jika pengguna telah mengisi teks refleksi pada aspek ini.
  bool get isFilled => content != null && content!.trim().isNotEmpty;

  /// Membuat salinan [DiaryDetail] dengan isi atau waktu pembaruan baru.
  DiaryDetail copyWith({
    String? detailId,
    String? diaryId,
    String? aspectId,
    DiaryAspect? aspect,
    String? content,
    DateTime? updatedAt,
  }) {
    return DiaryDetail(
      detailId: detailId ?? this.detailId,
      diaryId: diaryId ?? this.diaryId,
      aspectId: aspectId ?? this.aspectId,
      aspect: aspect ?? this.aspect,
      content: content ?? this.content,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Memetakan respons JSON API menjadi objek [DiaryDetail].
  factory DiaryDetail.fromJson(Map<String, dynamic> json) {
    final aspectJson = json['aspect'] as Map<String, dynamic>?;
    final parsedAspect = aspectJson != null
        ? DiaryAspect.fromJson(aspectJson)
        : DiaryAspect(
            aspectId: json['aspect_id']?.toString() ?? '',
            shortLabel: json['short_label']?.toString() ?? 'Aspek',
            title: json['aspect_title']?.toString() ?? 'Refleksi',
            question: json['question']?.toString() ?? '',
            description: json['description']?.toString() ?? '',
          );

    return DiaryDetail(
      detailId: json['detail_id']?.toString() ?? '',
      diaryId: json['diary_id']?.toString() ?? '',
      aspectId: json['aspect_id']?.toString() ?? parsedAspect.aspectId,
      aspect: parsedAspect,
      content: json['content']?.toString(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'].toString())
          : DateTime.now(),
    );
  }

  /// Mengonversi objek [DiaryDetail] menjadi format JSON untuk dikirim ke API.
  Map<String, dynamic> toJson() {
    return {
      'detail_id': detailId,
      'diary_id': diaryId,
      'aspect_id': aspectId,
      'content': content,
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
