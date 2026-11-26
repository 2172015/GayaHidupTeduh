import 'mood_level.dart';

enum MoodDimension {
  bahagia(
    label: 'Bahagia',
    question:
        'Seberapa cerah hatimu hari ini? Hal kecil apa yang memantik senyummu?',
    assetPath: 'assets/images/moodtracker/Bahagia.png',
    isNegative: false,
  ),
  puas(
    label: 'Puas',
    question: 'Seberapa utuh perasaanmu hari ini? Pencapaian apa yang sedang kau syukuri?',
    assetPath: 'assets/images/moodtracker/Puas.png',
    isNegative: false,
  ),
  energi(
    label: 'Energi',
    question: 'Seberapa penuh tenaga fisik dan batinmu? Apakah tubuhmu sedang meminta istirahat?',
    assetPath: 'assets/images/moodtracker/Energi.png',
    isNegative: false,
  ),
  cemas(
    label: 'Cemas',
    question: 'Seberapa riuh pikiranmu saat ini? Kekhawatiran apa yang sedang melintas?',
    assetPath: 'assets/images/moodtracker/Cemas.png',
    isNegative: true,
  ),
  marah(
    label: 'Marah',
    question: 'Seberapa panas emosimu hari ini? Apa yang sedang mengusik ketenanganmu?',
    assetPath: 'assets/images/moodtracker/Marah.png',
    isNegative: true,
  ),
  sedih(
    label: 'Sedih',
    question: 'Seberapa berat awan yang memayungi harimu? Adakah hal yang sedang membebanimu?',
    assetPath: 'assets/images/moodtracker/Sedih.png',
    isNegative: true,
  ),
  tenang(
    label: 'Tenang',
    question: 'Seberapa damai hening yang kau rasakan? Bagaimana caramu merawat jeda hari ini?',
    assetPath: 'assets/images/moodtracker/Tenang.png',
    isNegative: false,
  );

  final String label;
  final String question;
  final String assetPath;
  final bool isNegative;

  const MoodDimension({
    required this.label,
    required this.question,
    required this.assetPath,
    required this.isNegative,
  });

  /// Urutan tampilan 7 emosi pada kartu Detail 7 Emosi di halaman Riwayat Mood
  static const List<MoodDimension> historyDisplayOrder = [
    MoodDimension.bahagia,
    MoodDimension.tenang,
    MoodDimension.puas,
    MoodDimension.energi,
    MoodDimension.cemas,
    MoodDimension.marah,
    MoodDimension.sedih,
  ];

  /// Menentukan warna bar dinamis berdasarkan skor dan valensi emosi:
  /// - Positif: tinggi = hijau, tengah (5) = kuning Sand, rendah = merah
  /// - Negatif: tinggi = merah, tengah (5) = kuning Sand, rendah = hijau
  dynamic barColorForScore(int score) {
    final clamped = score.clamp(0, 10);
    final effectiveScore = isNegative ? (10 - clamped) : clamped;
    return MoodLevel.fromScore(effectiveScore).activeColor;
  }

  /// Menghitung rata-rata keseimbangan 7 emosi (skala 0.0 - 10.0)
  static double calculateOverallAverage(Map<MoodDimension, int> scores) {
    if (scores.isEmpty) return 5.0;

    double total = 0;
    for (final dimension in MoodDimension.values) {
      final raw = scores[dimension] ?? 5;
      total += dimension.isNegative ? (10 - raw) : raw;
    }
    return total / MoodDimension.values.length;
  }
}
