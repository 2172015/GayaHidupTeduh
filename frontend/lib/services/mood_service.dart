import '../models/mood_dimension.dart';
import '../models/mood_record.dart';

abstract class MoodService {
  Future<MoodRecord?> getRecordByDate(String userId, DateTime date);
  Future<MoodRecord> saveCheckIn({
    required String userId,
    required DateTime date,
    required Map<MoodDimension, int> scores,
  });
  Future<int> getCurrentStreak(String userId);
  Future<List<MoodRecord>> getHistory(String userId);
}

class MockMoodService implements MoodService {
  static int _streakDays = 30;

  static final List<MoodRecord> _records = _seedDummyRecords();

  static List<MoodRecord> _seedDummyRecords() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    return [
      MoodRecord(
        moodId: 'MOOD-278392-TODAY',
        userId: '278392',
        date: today,
        scores: const {
          MoodDimension.bahagia: 8,
          MoodDimension.tenang: 5,
          MoodDimension.puas: 6,
          MoodDimension.energi: 9,
          MoodDimension.cemas: 7,
          MoodDimension.marah: 1,
          MoodDimension.sedih: 3,
        },
        createdAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now.subtract(const Duration(hours: 2)),
      ),
      MoodRecord(
        moodId: 'MOOD-278392-YESTERDAY',
        userId: '278392',
        date: yesterday,
        scores: const {
          MoodDimension.bahagia: 7,
          MoodDimension.tenang: 8,
          MoodDimension.puas: 7,
          MoodDimension.energi: 6,
          MoodDimension.cemas: 3,
          MoodDimension.marah: 2,
          MoodDimension.sedih: 2,
        },
        createdAt: yesterday.add(const Duration(hours: 20)),
        updatedAt: yesterday.add(const Duration(hours: 20)),
      ),
    ];
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Future<MoodRecord?> getRecordByDate(String userId, DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 250));
    for (final record in _records) {
      if (record.userId == userId && _isSameDay(record.date, date)) {
        return record;
      }
    }
    return null;
  }

  @override
  Future<MoodRecord> saveCheckIn({
    required String userId,
    required DateTime date,
    required Map<MoodDimension, int> scores,
  }) async {
    await Future.delayed(const Duration(milliseconds: 450));
    final now = DateTime.now();
    final existingIndex = _records.indexWhere(
      (r) => r.userId == userId && _isSameDay(r.date, date),
    );

    if (existingIndex != -1) {
      final updated = _records[existingIndex].copyWith(
        scores: scores,
        updatedAt: now,
      );
      _records[existingIndex] = updated;
      return updated;
    }

    final normalizedDate = DateTime(date.year, date.month, date.day);
    final newRecord = MoodRecord(
      moodId: 'MOOD-$userId-${normalizedDate.millisecondsSinceEpoch}',
      userId: userId,
      date: normalizedDate,
      scores: Map<MoodDimension, int>.from(scores),
      createdAt: now,
      updatedAt: now,
    );
    _records.add(newRecord);
    _streakDays += 1;
    return newRecord;
  }

  @override
  Future<int> getCurrentStreak(String userId) async {
    return _streakDays;
  }

  @override
  Future<List<MoodRecord>> getHistory(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final userRecords = _records.where((r) => r.userId == userId).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return userRecords;
  }
}
