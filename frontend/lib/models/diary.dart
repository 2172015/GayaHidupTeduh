import 'diary_aspect.dart';

class Diary {
  final String diaryId;
  final String userId;
  final String title;
  final String? godContent;
  final String? belovedContent;
  final String? feelingContent;
  final String? lifestyleContent;
  final String? passionContent;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const Diary({
    required this.diaryId,
    required this.userId,
    required this.title,
    this.godContent,
    this.belovedContent,
    this.feelingContent,
    this.lifestyleContent,
    this.passionContent,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  bool get isDeleted => deletedAt != null;

  /// Mengambil konten berdasarkan enum DiaryAspect
  String? contentFor(DiaryAspect aspect) {
    switch (aspect) {
      case DiaryAspect.god:
        return godContent;
      case DiaryAspect.beloved:
        return belovedContent;
      case DiaryAspect.feeling:
        return feelingContent;
      case DiaryAspect.lifestyle:
        return lifestyleContent;
      case DiaryAspect.passion:
        return passionContent;
    }
  }

  /// Menentukan warna pill di DiaryCard (Sand jika terisi, Abu-abu jika kosong)
  bool isAspectFilled(DiaryAspect aspect) {
    final text = contentFor(aspect);
    return text != null && text.trim().isNotEmpty;
  }

  String get formattedCreatedDate => _formatIndoDate(createdAt);
  String get formattedUpdatedDate => _formatIndoDate(updatedAt);

  static String _formatIndoDate(DateTime date) {
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

  /// Generator ID: USERID + DDMMYYYY + 001 (contoh: 27839224112026001)
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

  Diary copyWith({
    String? diaryId,
    String? userId,
    String? title,
    String? godContent,
    String? belovedContent,
    String? feelingContent,
    String? lifestyleContent,
    String? passionContent,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return Diary(
      diaryId: diaryId ?? this.diaryId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      godContent: godContent ?? this.godContent,
      belovedContent: belovedContent ?? this.belovedContent,
      feelingContent: feelingContent ?? this.feelingContent,
      lifestyleContent: lifestyleContent ?? this.lifestyleContent,
      passionContent: passionContent ?? this.passionContent,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory Diary.fromJson(Map<String, dynamic> json) {
    return Diary(
      diaryId: json['diary_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      title: json['title'] ?? '',
      godContent: json['god_content'],
      belovedContent: json['beloved_content'],
      feelingContent: json['feeling_content'],
      lifestyleContent: json['lifestyle_content'],
      passionContent: json['passion_content'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'diary_id': diaryId,
      'user_id': userId,
      'title': title,
      'god_content': godContent,
      'beloved_content': belovedContent,
      'feeling_content': feelingContent,
      'lifestyle_content': lifestyleContent,
      'passion_content': passionContent,
    };
  }
}
