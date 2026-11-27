/// Model master aspek refleksi untuk fitur Me & My Everyday Story.
library;

/// Merepresentasikan satu aspek kehidupan beserta pertanyaan pemandu dan deskripsinya.
///
/// Daftar aspek aktif dikelola secara terpusat agar dapat ditambah, diubah,
/// atau dinonaktifkan di masa depan tanpa merusak riwayat [Diary] lama.
class DiaryAspect {
  /// Pengenal unik aspek (Primary Key, contoh: `'god'`, `'beloved'`).
  final String aspectId;

  /// Label singkat untuk badge/chip pada [DiaryCard] (contoh: `'God'`).
  final String shortLabel;

  /// Judul lengkap aspek tanpa nomor urut (contoh: `'Me & My God'`).
  final String title;

  /// Pertanyaan reflektif utama yang memandu pengguna menulis.
  final String question;

  /// Deskripsi atau teks petunjuk (*placeholder*) di dalam kotak input.
  final String description;

  /// Batas maksimal jumlah karakter yang dapat diisi pada aspek ini.
  final int maxChar;

  /// Menentukan apakah aspek masih aktif digunakan untuk halaman baru.
  final bool isActive;

  const DiaryAspect({
    required this.aspectId,
    required this.shortLabel,
    required this.title,
    required this.question,
    required this.description,
    this.maxChar = 1000,
    this.isActive = true,
  });

  /// Daftar ID aspek yang dipilih untuk ditampilkan saat membuat halaman baru.
  ///
  /// Sistem akan mencocokkan ID di dalam daftar ini dengan master [DiaryAspect]
  /// yang tersedia; jika ditemukan maka aspek akan dimuat sesuai urutan ini.
  static const List<String> activeAspectIds = [
    'god',
    'beloved',
    'feeling',
    'lifestyle',
    'passion',
  ];

  /// Daftar master 5 aspek utama bawaan aplikasi **Gaya Hidup Teduh**.
  static const List<DiaryAspect> defaultMasterAspects = [
    DiaryAspect(
      aspectId: 'god',
      shortLabel: 'God',
      title: 'Me & My God',
      question: 'Apakah hari ini kau sudah bercakap-cakap dengan Tuhan?',
      description: 'Sikap hatimu untuk menyapa Tuhan dengan penuh cinta hari ini. Pesan yang kau dapatkan pada waktu kau datang pada Tuhan dan berdoa. Peristiwa yang membuatmu merasa Tuhan sungguh hadir sangat dekat di hidupmu...',
    ),
    DiaryAspect(
      aspectId: 'beloved',
      shortLabel: 'Beloved',
      title: 'Me & My Beloved',
      question: 'Apakah hari ini kau digerakkan Tuhan melakukan sesuatu untuk seseorang?',
      description: 'Hal-hal yang kau lakukan untuk menunjukkan kasih dan perhatian kepada orang-orang di sekitarmu. Kegiatan yang kau lakukan untuk membangun waktu yang berkualitas bersama keluarga...',
    ),
    DiaryAspect(
      aspectId: 'feeling',
      shortLabel: 'Feeling',
      title: 'Me & My Feeling',
      question: 'Perasaan apa yang paling dominan hadir di hatimu hari ini?',
      description: 'Ceritakan emosi yang kamu rasakan hari ini, apa yang memicunya, dan bagaimana kamu merespons perasaan tersebut dengan jujur...',
    ),
    DiaryAspect(
      aspectId: 'lifestyle',
      shortLabel: 'Lifestyle',
      title: 'Me & My Lifestyle',
      question: 'Bagaimana kamu menjaga ritme tubuh dan keseharianmu hari ini?',
      description: 'Kebiasaan baik, pola istirahat, olahraga, atau langkah kecil menjaga kesehatan fisik dan mental yang kamu lakukan hari ini...',
    ),
    DiaryAspect(
      aspectId: 'passion',
      shortLabel: 'Passion',
      title: 'Me & My Passion',
      question: 'Hal bermakna apa yang kamu kerjakan atau pelajari hari ini?',
      description: 'Progres studi, karya, hobi, atau hal yang membuatmu bersemangat dan bertumbuh hari ini...',
    ),
  ];

  /// Membuat salinan [DiaryAspect] dengan pembaruan properti tertentu.
  DiaryAspect copyWith({
    String? aspectId,
    String? shortLabel,
    String? title,
    String? question,
    String? description,
    int? maxChar,
    bool? isActive,
  }) {
    return DiaryAspect(
      aspectId: aspectId ?? this.aspectId,
      shortLabel: shortLabel ?? this.shortLabel,
      title: title ?? this.title,
      question: question ?? this.question,
      description: description ?? this.description,
      maxChar: maxChar ?? this.maxChar,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Memetakan respons JSON API menjadi objek [DiaryAspect].
  factory DiaryAspect.fromJson(Map<String, dynamic> json) {
    return DiaryAspect(
      aspectId: json['aspect_id']?.toString() ?? '',
      shortLabel: json['short_label']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      question: json['question']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      maxChar: json['max_char'] as int? ?? 1000,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  /// Mengonversi objek [DiaryAspect] menjadi format JSON.
  Map<String, dynamic> toJson() {
    return {
      'aspect_id': aspectId,
      'short_label': shortLabel,
      'title': title,
      'question': question,
      'description': description,
      'max_char': maxChar,
      'is_active': isActive,
    };
  }
}
