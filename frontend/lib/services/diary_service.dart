/// Kontrak layanan dan implementasi mock untuk pengelolaan data Diary.
library;

import '../models/diary.dart';
import '../models/diary_aspect.dart';
import '../models/diary_detail.dart';

/// Kontrak layanan CRUD untuk halaman [Diary], relasi [DiaryDetail],
/// serta pengambilan daftar aspek aktif dari master [DiaryAspect].
abstract class DiaryService {
  /// Mengambil daftar aspek yang aktif untuk pembuatan halaman baru berdasarkan
  /// daftar [DiaryAspect.activeAspectIds] yang dicocokkan ke master aspek.
  Future<List<DiaryAspect>> getFormAspects();

  /// Mengambil seluruh halaman diary aktif milik [userId] terurut dari yang terbaru.
  Future<List<Diary>> getDiaries(String userId);

  /// Membuat halaman diary baru beserta isi refleksi per aspek ([aspectContents]).
  Future<Diary> createDiary({
    required String userId,
    required String title,
    required List<DiaryAspect> aspects,
    required Map<String, String> aspectContents,
  });

  /// Memperbarui judul dan isi refleksi pada halaman [diary] yang masih berada
  /// di hari pembuatannya (sebelum pukul 23:59 waktu lokal).
  Future<Diary> updateDiary(Diary diary);

  /// Menghapus halaman diary berdasarkan [diaryId].
  Future<void> deleteDiary(String diaryId);
}

/// Implementasi mock [DiaryService] untuk kebutuhan pengembangan lokal.
class MockDiaryService implements DiaryService {
  /// Master aspek yang tersedia di sistem (simulasi tabel `diary_aspects`).
  final List<DiaryAspect> _masterAspects = List<DiaryAspect>.from(
    DiaryAspect.defaultMasterAspects,
  );

  static final List<Diary> _diaries = _buildSeedDiaries();

  static List<Diary> _buildSeedDiaries() {
    final aspects = DiaryAspect.defaultMasterAspects;
    final now = DateTime.now();

    DiaryDetail makeDetail(
      String diaryId,
      DiaryAspect aspect,
      String? content,
      DateTime updatedAt,
    ) {
      return DiaryDetail(
        detailId: '${diaryId}_${aspect.aspectId}',
        diaryId: diaryId,
        aspectId: aspect.aspectId,
        aspect: aspect,
        content: content,
        updatedAt: updatedAt,
      );
    }

    // 1. Arsip 2 bulan lalu (terkunci & masuk arsip)
    final archiveOlderDate = DateTime(now.year, now.month - 2, 14, 20, 15);
    final archiveOlderId = Diary.generateDiaryId(
      userId: '278392',
      date: archiveOlderDate,
      dailyIndex: 1,
    );

    // 2. Arsip bulan lalu (terkunci & masuk arsip)
    final archiveLastMonthDate = DateTime(now.year, now.month - 1, 21, 19, 40);
    final archiveLastMonthId = Diary.generateDiaryId(
      userId: '278392',
      date: archiveLastMonthDate,
      dailyIndex: 1,
    );

    // 3. Bulan ini namun hari sebelumnya (tampil di DiaryScreen, tapi sudah terkunci)
    final earlierThisMonthDate = now.day > 3
        ? DateTime(now.year, now.month, now.day - 3, 21, 10)
        : DateTime(now.year, now.month, 1, 8, 0);
    final earlierThisMonthId = Diary.generateDiaryId(
      userId: '278392',
      date: earlierThisMonthDate,
      dailyIndex: 1,
    );

    // 4. Hari ini (tampil paling atas di DiaryScreen & masih dapat disunting hingga 23:59)
    final todayDate = DateTime(now.year, now.month, now.day, 8, 30);
    final todayId = Diary.generateDiaryId(
      userId: '278392',
      date: todayDate,
      dailyIndex: 1,
    );

    return [
      Diary(
        diaryId: archiveOlderId,
        userId: '278392',
        title: 'Langkah Kecil di Tengah Hujan',
        createdAt: archiveOlderDate,
        updatedAt: archiveOlderDate,
        details: [
          makeDetail(
            archiveOlderId,
            aspects[0],
            'Bersyukur tetap diberi ketenangan saat menghadapi perubahan jadwal.',
            archiveOlderDate,
          ),
          makeDetail(archiveOlderId, aspects[1], null, archiveOlderDate),
          makeDetail(
            archiveOlderId,
            aspects[2],
            'Sedikit lelah namun merasa lega setelah menuliskan isi pikiran.',
            archiveOlderDate,
          ),
          makeDetail(archiveOlderId, aspects[3], null, archiveOlderDate),
          makeDetail(
            archiveOlderId,
            aspects[4],
            'Membaca kembali catatan perancangan sistem.',
            archiveOlderDate,
          ),
        ],
      ),
      Diary(
        diaryId: archiveLastMonthId,
        userId: '278392',
        title: 'Perjalanan yang Sulit Namun Bermakna',
        createdAt: archiveLastMonthDate,
        updatedAt: archiveLastMonthDate,
        details: [
          makeDetail(
            archiveLastMonthId,
            aspects[0],
            'Mengingat kembali bahwa setiap proses bertumbuh membutuhkan kesabaran.',
            archiveLastMonthDate,
          ),
          makeDetail(
            archiveLastMonthId,
            aspects[1],
            'Berterima kasih kepada keluarga yang selalu mendukung dari rumah.',
            archiveLastMonthDate,
          ),
          makeDetail(
            archiveLastMonthId,
            aspects[2],
            'Sempat lelah di siang hari, namun perlahan membaik setelah beristirahat sejenak.',
            archiveLastMonthDate,
          ),
          makeDetail(
            archiveLastMonthId,
            aspects[3],
            null,
            archiveLastMonthDate,
          ),
          makeDetail(
            archiveLastMonthId,
            aspects[4],
            null,
            archiveLastMonthDate,
          ),
        ],
      ),
      Diary(
        diaryId: earlierThisMonthId,
        userId: '278392',
        title: 'Menemukan Tenang',
        createdAt: earlierThisMonthDate,
        updatedAt: earlierThisMonthDate,
        details: [
          makeDetail(
            earlierThisMonthId,
            aspects[0],
            'Belajar berserah saat jadwal kegiatan kampus terasa padat.',
            earlierThisMonthDate,
          ),
          makeDetail(
            earlierThisMonthId,
            aspects[1],
            'Menemani teman berdiskusi dan mendengarkan ceritanya dengan penuh perhatian.',
            earlierThisMonthDate,
          ),
          makeDetail(
            earlierThisMonthId,
            aspects[2],
            null,
            earlierThisMonthDate,
          ),
          makeDetail(
            earlierThisMonthId,
            aspects[3],
            'Mengurangi konsumsi gula dan minum air putih lebih teratur.',
            earlierThisMonthDate,
          ),
          makeDetail(
            earlierThisMonthId,
            aspects[4],
            null,
            earlierThisMonthDate,
          ),
        ],
      ),
      Diary(
        diaryId: todayId,
        userId: '278392',
        title: 'Kedamaian Hari Ini',
        createdAt: todayDate,
        updatedAt: todayDate,
        details: [
          makeDetail(
            todayId,
            aspects[0],
            'Bersyukur pagi ini bisa memulai hari dengan doa yang tenang.',
            todayDate,
          ),
          makeDetail(todayId, aspects[1], null, todayDate),
          makeDetail(
            todayId,
            aspects[2],
            'Hati terasa lebih ringan setelah mencatat hal-hal kecil yang berjalan baik.',
            todayDate,
          ),
          makeDetail(
            todayId,
            aspects[3],
            'Tidur cukup 7 jam dan menyempatkan jalan kaki sore 20 menit.',
            todayDate,
          ),
          makeDetail(
            todayId,
            aspects[4],
            'Menyelesaikan perancangan struktur database untuk aplikasi tugas akhir.',
            todayDate,
          ),
        ],
      ),
    ];
  }

  @override
  Future<List<DiaryAspect>> getFormAspects() async {
    await Future.delayed(const Duration(milliseconds: 120));
    final aspectById = {
      for (final aspect in _masterAspects)
        if (aspect.isActive) aspect.aspectId: aspect,
    };

    final resolved = <DiaryAspect>[];
    for (final id in DiaryAspect.activeAspectIds) {
      final matched = aspectById[id];
      if (matched != null) {
        resolved.add(matched);
      }
    }
    return resolved;
  }

  @override
  Future<List<Diary>> getDiaries(String userId) async {
    await Future.delayed(const Duration(milliseconds: 220));
    final active =
        _diaries.where((d) => !d.isDeleted && d.userId == userId).toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return active;
  }

  @override
  Future<Diary> createDiary({
    required String userId,
    required String title,
    required List<DiaryAspect> aspects,
    required Map<String, String> aspectContents,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final now = DateTime.now();
    final newId = Diary.generateDiaryId(
      userId: userId,
      date: now,
      dailyIndex: _diaries.length + 1,
    );

    final details = aspects.map((aspect) {
      final rawText = aspectContents[aspect.aspectId]?.trim();
      return DiaryDetail(
        detailId: '${newId}_${aspect.aspectId}',
        diaryId: newId,
        aspectId: aspect.aspectId,
        aspect: aspect,
        content: (rawText == null || rawText.isEmpty) ? null : rawText,
        updatedAt: now,
      );
    }).toList();

    final created = Diary(
      diaryId: newId,
      userId: userId,
      title: title.trim(),
      details: details,
      createdAt: now,
      updatedAt: now,
    );

    _diaries.add(created);
    return created;
  }

  @override
  Future<Diary> updateDiary(Diary diary) async {
    if (!diary.canEdit) {
      throw StateError(
        'Batas waktu penyuntingan diary (23:59 di hari yang sama) telah berakhir.',
      );
    }

    await Future.delayed(const Duration(milliseconds: 250));
    final now = DateTime.now();
    final updated = diary.copyWith(updatedAt: now);
    final index = _diaries.indexWhere((d) => d.diaryId == diary.diaryId);
    if (index != -1) {
      _diaries[index] = updated;
    }
    return updated;
  }

  @override
  Future<void> deleteDiary(String diaryId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _diaries.indexWhere((d) => d.diaryId == diaryId);
    if (index != -1) {
      _diaries[index] = _diaries[index].copyWith(deletedAt: DateTime.now());
    }
  }
}
