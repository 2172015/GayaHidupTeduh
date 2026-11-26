import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../models/diary.dart';
import '../../../models/diary_aspect.dart';

class DiaryCard extends StatelessWidget {
  final int dayNumber;
  final Diary diary;
  final VoidCallback onTap;

  const DiaryCard({
    super.key,
    required this.dayNumber,
    required this.diary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.forestGreen.withValues(alpha: 0.25),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          splashColor: AppColors.sageGreen.withValues(alpha: 0.25),
          highlightColor: AppColors.sageGreen.withValues(alpha: 0.12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Baris 1: Day #1: & Tanggal Dibuat
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Day #$dayNumber:',
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                    Text(
                      diary.formattedCreatedDate,
                      style: const TextStyle(
                        fontSize: 14.5,
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
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
                const SizedBox(height: 10),

                // Baris 3: Last Update
                Text(
                  'Last update: ${diary.formattedUpdatedDate}',
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.forestGreen,
                  ),
                ),
                const SizedBox(height: 10),

                // Baris 4: 5 Pill Status Aspek (Sand jika terisi, Abu-abu jika kosong)
                Row(
                  children: DiaryAspect.values.map((aspect) {
                    final isFilled = diary.isAspectFilled(aspect);
                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                          right: aspect == DiaryAspect.passion ? 0 : 6,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          color: isFilled
                              ? const Color(0xFFE9D8A6)
                              : const Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          aspect.shortLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E1E1E),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}