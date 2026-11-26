import '../models/diary.dart';

abstract class DiaryService {
  Future<List<Diary>> getDiaries(String userId);
  Future<Diary> createDiary({
    required String userId,
    required String title,
    String? godContent,
    String? belovedContent,
    String? feelingContent,
    String? lifestyleContent,
    String? passionContent,
  });
  Future<Diary> updateDiary(Diary diary);
  Future<void> deleteDiary(String diaryId);
}

class MockDiaryService implements DiaryService {
  static final List<Diary> _storage = [
    Diary(
      diaryId: '27839221102026001',
      userId: '278392',
      title: 'Kedamaian Hari Ini',
      godContent: 'Hari ini memulai pagi dengan doa singkat sebelum beraktivitas. Merasa sangat tenang dan dibimbing dalam mengambil keputusan.',
      belovedContent: null,
      feelingContent:
          'Hati terasa damai dan tidak terburu-buru meski jadwal cukup padat.',
      lifestyleContent: 'Berhasil tidur cukup 7 jam dan mengurangi konsumsi kafein sore hari.',
      passionContent:
          'Menyelesaikan rancangan arsitektur aplikasi Teduh dengan lancar.',
      createdAt: DateTime(2026, 10, 21, 9, 0),
      updatedAt: DateTime(2026, 10, 24, 14, 30),
    ),
    Diary(
      diaryId: '27839222102026001',
      userId: '278392',
      title: 'Menemukan Tenang',
      godContent: 'Bersyukur atas kekuatan dan kesehatan yang masih diberikan sampai hari ini.',
      belovedContent:
          'Membantu teman yang sedang kesulitan memahami materi kuliah.',
      feelingContent: null,
      lifestyleContent:
          'Jalan santai sore selama 20 menit untuk menyegarkan pikiran.',
      passionContent: null,
      createdAt: DateTime(2026, 10, 22, 19, 15),
      updatedAt: DateTime(2026, 10, 26, 10, 0),
    ),
    Diary(
      diaryId: '27839223102026001',
      userId: '278392',
      title: 'Perjalanan yang Sulit ...',
      godContent:
          'Berdoa memohon kesabaran saat menghadapi kendala teknis hari ini.',
      belovedContent:
          'Bercerita dengan keluarga di rumah dan mendapat dukungan penuh.',
      feelingContent: 'Sempat merasa lelah di siang hari, namun perlahan membaik di malam hari.',
      lifestyleContent: null,
      passionContent: null,
      createdAt: DateTime(2026, 10, 23, 21, 0),
      updatedAt: DateTime(2026, 10, 29, 8, 45),
    ),
  ];

  @override
  Future<List<Diary>> getDiaries(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _storage.where((d) => d.userId == userId && !d.isDeleted).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  @override
  Future<Diary> createDiary({
    required String userId,
    required String title,
    String? godContent,
    String? belovedContent,
    String? feelingContent,
    String? lifestyleContent,
    String? passionContent,
  }) async {
    await Future.delayed(const Duration(milliseconds: 450));
    final now = DateTime.now();

    // Hitung jumlah diary user di tanggal yang sama untuk index 001, 002, dst.
    final sameDayCount = _storage.where((d) {
      return d.userId == userId &&
          d.createdAt.year == now.year &&
          d.createdAt.month == now.month &&
          d.createdAt.day == now.day;
    }).length;

    final newDiary = Diary(
      diaryId: Diary.generateDiaryId(
        userId: userId,
        date: now,
        dailyIndex: sameDayCount + 1,
      ),
      userId: userId,
      title: title,
      godContent: _normalizeNullable(godContent),
      belovedContent: _normalizeNullable(belovedContent),
      feelingContent: _normalizeNullable(feelingContent),
      lifestyleContent: _normalizeNullable(lifestyleContent),
      passionContent: _normalizeNullable(passionContent),
      createdAt: now,
      updatedAt: now,
    );

    _storage.add(newDiary);
    return newDiary;
  }

  @override
  Future<Diary> updateDiary(Diary diary) async {
    await Future.delayed(const Duration(milliseconds: 450));
    final index = _storage.indexWhere((d) => d.diaryId == diary.diaryId);
    final updated = diary.copyWith(
      godContent: _normalizeNullable(diary.godContent),
      belovedContent: _normalizeNullable(diary.belovedContent),
      feelingContent: _normalizeNullable(diary.feelingContent),
      lifestyleContent: _normalizeNullable(diary.lifestyleContent),
      passionContent: _normalizeNullable(diary.passionContent),
      updatedAt: DateTime.now(),
    );
    if (index != -1) {
      _storage[index] = updated;
    }
    return updated;
  }

  @override
  Future<void> deleteDiary(String diaryId) async {
    await Future.delayed(const Duration(milliseconds: 350));
    final index = _storage.indexWhere((d) => d.diaryId == diaryId);
    if (index != -1) {
      _storage[index] = _storage[index].copyWith(deletedAt: DateTime.now());
    }
  }

  String? _normalizeNullable(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return value.trim();
  }
}
