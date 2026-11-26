import 'mood_dimension.dart';

class MoodRecord {
  final String moodId;
  final String userId;
  final DateTime date;
  final Map<MoodDimension, int> scores;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MoodRecord({
    required this.moodId,
    required this.userId,
    required this.date,
    required this.scores,
    required this.createdAt,
    required this.updatedAt,
  });

  int scoreFor(MoodDimension dimension) => scores[dimension] ?? 5;

  /// Computed property lokal: rata-rata keseimbangan 7 emosi
  double get overallAverage => MoodDimension.calculateOverallAverage(scores);

  /// Computed property lokal: emosi dengan skor intensitas tertinggi
  MoodDimension get dominantMood {
    MoodDimension highest = MoodDimension.bahagia;
    int maxScore = -1;

    for (final dimension in MoodDimension.historyDisplayOrder) {
      final current = scoreFor(dimension);
      if (current > maxScore) {
        maxScore = current;
        highest = dimension;
      }
    }
    return highest;
  }

  String get formattedDate {
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
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  MoodRecord copyWith({
    String? moodId,
    String? userId,
    DateTime? date,
    Map<MoodDimension, int>? scores,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MoodRecord(
      moodId: moodId ?? this.moodId,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      scores: scores ?? Map<MoodDimension, int>.from(this.scores),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory MoodRecord.fromJson(Map<String, dynamic> json) {
    return MoodRecord(
      moodId: json['mood_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      date: DateTime.parse(json['date']),
      scores: {
        MoodDimension.bahagia: json['bahagia'] ?? 5,
        MoodDimension.tenang: json['tenang'] ?? 5,
        MoodDimension.puas: json['puas'] ?? 5,
        MoodDimension.energi: json['energi'] ?? 5,
        MoodDimension.cemas: json['cemas'] ?? 5,
        MoodDimension.marah: json['marah'] ?? 5,
        MoodDimension.sedih: json['sedih'] ?? 5,
      },
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mood_id': moodId,
      'user_id': userId,
      'date': date.toIso8601String().split('T').first,
      'bahagia': scoreFor(MoodDimension.bahagia),
      'tenang': scoreFor(MoodDimension.tenang),
      'puas': scoreFor(MoodDimension.puas),
      'energi': scoreFor(MoodDimension.energi),
      'cemas': scoreFor(MoodDimension.cemas),
      'marah': scoreFor(MoodDimension.marah),
      'sedih': scoreFor(MoodDimension.sedih),
    };
  }
}
