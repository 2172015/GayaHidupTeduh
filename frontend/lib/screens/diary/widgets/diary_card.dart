/// Kartu ringkasan satu halaman diary yang mewarisi [DefaultCard].
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_theme.dart';
import '../../../models/diary.dart';
import '../../../models/diary_detail.dart';
import '../../../widgets/cards/default_card.dart';

/// Kartu daftar halaman cerita pada [DiaryScreen] yang mewarisi [DefaultCard].
///
/// Menampilkan urutan hari (`Day #1:`), tanggal pembuatan, judul cerita,
/// waktu pembaruan terakhir, serta baris *pill* status aspek:
/// - **5 aspek atau kurang:** Tersebar merata mengikuti lebar kartu.
/// - **Lebih dari 5 aspek:** Dapat digulir (*scroll*) secara horizontal.
class DiaryCard extends DefaultCard {
  /// Nomor urut hari halaman cerita.
  final int dayNumber;

  /// Data halaman [Diary] beserta daftar [DiaryDetail]-nya.
  final Diary diary;

  const DiaryCard({
    super.key,
    required this.dayNumber,
    required this.diary,
    required VoidCallback super.onTap,
    super.isActive,
    super.isEnabled,
  }) : super(
         borderRadius: 18,
         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
       );

  @override
  Widget buildCardBody(BuildContext context) {
    final details = diary.details;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Baris 1: Day #1: & Tanggal Dibuat
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Day #$dayNumber:',
              style: AppTextTheme.cardTitle(fontSize: 15.5),
            ),
            Text(
              diary.formattedCreatedDate,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.forestGreen,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),

        // Baris 2: Judul Halaman Diary
        Text(
          diary.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.bodyText,
          ),
        ),
        const SizedBox(height: 10),

        // Baris 3: Last Update
        Text(
          'Last update: ${diary.formattedUpdatedDate}',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.forestGreen,
          ),
        ),
        const SizedBox(height: 10),

        // Baris 4: Pill Status Aspek (<= 5 tersebar penuh, > 5 scroll horizontal)
        _buildAspectChipsRow(details),
      ],
    );
  }

  Widget _buildAspectChipsRow(List<DiaryDetail> details) {
    if (details.isEmpty) return const SizedBox.shrink();

    if (details.length <= 5) {
      return Row(
        children: List.generate(details.length, (index) {
          final detail = details[index];
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: index == details.length - 1 ? 0 : 6,
              ),
              child: _buildAspectChip(detail, isScrollable: false),
            ),
          );
        }),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(details.length, (index) {
          final detail = details[index];
          return Padding(
            padding: EdgeInsets.only(
              right: index == details.length - 1 ? 0 : 6,
            ),
            child: _buildAspectChip(detail, isScrollable: true),
          );
        }),
      ),
    );
  }

  Widget _buildAspectChip(DiaryDetail detail, {required bool isScrollable}) {
    final isFilled = detail.isFilled;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isScrollable ? 12 : 4,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: isFilled ? AppColors.sand : AppColors.lightGray,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        detail.aspect.shortLabel,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.bodyText,
        ),
      ),
    );
  }
}
