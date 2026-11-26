import 'package:flutter/material.dart';

/// Palet warna terpusat untuk seluruh antarmuka aplikasi **Gaya Hidup Teduh**.
///
/// Gunakan konstanta di kelas ini untuk menjaga konsistensi warna
/// dan hindari penulisan kode hex `Color(0xFF...)` secara langsung di widget.
class AppColors {
  AppColors._();

  // Warna Utama Tema
  /// Hijau pastel lembut (`#B0D182`) untuk tombol aksi utama dan aksen aktif.
  static const Color sageGreen = Color(0xFFB0D182);

  /// Hijau sage (`#9AB08A`) untuk bagian bawah gradasi latar belakang layar.
  static const Color gradientSage = Color(0xFF9AB08A);

  /// Hijau hutan gelap (`#2C473E`) untuk judul utama, ikon aktif, dan teks penekanan.
  static const Color forestGreen = Color(0xFF2C473E);

  /// Hijau hutan terang (`#6A8E4E`) untuk aksen sekunder dan indikator progres.
  static const Color lightForestGreen = Color(0xFF6A8E4E);

  /// Krem hangat (`#F4F1EA`) sebagai warna dasar layar dan permukaan kartu.
  static const Color offWhite = Color(0xFFF4F1EA);

  /// Krem keemasan (`#E9D8A6`) untuk sorotan tingkat mood *Balance* dan label voucher.
  static const Color sand = Color(0xFFE9D8A6);

  /// Abu-abu terang (`#D9D9D9`) untuk garis pembatas netral dan elemen nonaktif.
  static const Color lightGray = Color(0xFFD9D9D9);

  // Netral & Teks
  /// Putih murni (`#FFFFFF`) untuk permukaan input, wadah tombol bawah, dan teks kontras.
  static const Color pureWhite = Color(0xFFFFFFFF);

  /// Hitam pekat (`#000000`) untuk bayangan (*box shadow*) dengan opasitas rendah.
  static const Color black = Color(0xFF000000);

  /// Cokelat-arang hangat (`#383329`) sebagai warna default teks isi (*body text*).
  static const Color bodyText = Color(0xFF383329);

  /// Hijau keabu-abuan (`#7D9378`) untuk teks *eyebrow* merek dan keterangan sekunder.
  static const Color mutedText = Color(0xFF7D9378);

  // Status & Error
  /// Merah *crimson* hangat (`#C84B4B`) untuk pesan validasi error dan aksi hapus/batal.
  static const Color errorRed = Color(0xFFC84B4B);

  /// Merah muda lembut (`#FADADA`) sebagai latar tombol atau banner peringatan error.
  static const Color errorBackground = Color(0xFFFADADA);
}