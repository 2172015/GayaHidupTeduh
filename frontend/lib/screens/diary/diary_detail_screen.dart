/// Halaman detail baca untuk satu halaman cerita diary.
library;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/diary.dart';
import '../../services/diary_service.dart';
import '../../widgets/cards/default_card.dart';
import '../../widgets/common/teduh_bottom_action_bar.dart';
import '../../widgets/common/teduh_confirm_dialog.dart';
import '../../widgets/common/teduh_loading_overlay.dart';
import '../../widgets/common/teduh_scaffold.dart';
import 'diary_form_screen.dart';
import 'widgets/diary_aspect_card.dart';

/// Layar tampilan baca untuk melihat seluruh isi refleksi pada satu [Diary].
///
/// Tombol penyuntingan hanya tersedia hingga pukul 23:59 waktu lokal pada
/// hari halaman diary tersebut dibuat ([Diary.canEdit]).
class DiaryDetailScreen extends StatefulWidget {
  /// Nomor urut hari yang ditampilkan pada header halaman.
  final int dayNumber;

  /// Data halaman diary yang sedang dibuka.
  final Diary diary;

  /// Layanan data diary untuk aksi pembaruan dan penghapusan.
  final DiaryService diaryService;

  const DiaryDetailScreen({
    super.key,
    required this.dayNumber,
    required this.diary,
    required this.diaryService,
  });

  @override
  State<DiaryDetailScreen> createState() => _DiaryDetailScreenState();
}

class _DiaryDetailScreenState extends State<DiaryDetailScreen> {
  late Diary _currentDiary;
  bool _hasUpdated = false;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _currentDiary = widget.diary;
  }

  Future<void> _goToEdit() async {
    if (!_currentDiary.canEdit) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Batas waktu penyuntingan (23:59 di hari pembuatan) telah berakhir.',
          ),
          backgroundColor: AppColors.errorRed,
        ),
      );
      return;
    }

    final updatedDiary = await Navigator.push<Diary>(
      context,
      MaterialPageRoute<Diary>(
        builder: (_) => DiaryFormScreen(
          userId: _currentDiary.userId,
          diaryService: widget.diaryService,
          dayNumber: widget.dayNumber,
          existingDiary: _currentDiary,
        ),
      ),
    );

    if (updatedDiary != null && mounted) {
      setState(() {
        _currentDiary = updatedDiary;
        _hasUpdated = true;
      });
    }
  }

  Future<void> _confirmAndDelete() async {
    final confirmed = await TeduhConfirmDialog.show(
      context,
      title: 'Hapus Cerita Ini?',
      message:
          'Halaman "Day #${widget.dayNumber}: ${_currentDiary.title}" akan dihapus dari daftar ceritamu.',
      confirmLabel: 'Hapus',
      isDestructive: true,
    );

    if (confirmed) {
      setState(() => _isDeleting = true);
      await widget.diaryService.deleteDiary(_currentDiary.diaryId);
      if (!mounted) return;
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final canEdit = _currentDiary.canEdit;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) Navigator.pop(context, _hasUpdated);
      },
      child: TeduhLoadingOverlay(
        isLoading: _isDeleting,
        message: 'Menghapus cerita...',
        child: TeduhScaffold(
          title: 'Me & My Everyday Story',
          onBackPressed: () => Navigator.pop(context, _hasUpdated),
          appBarActions: [
            IconButton(
              tooltip: 'Hapus Diary',
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.errorRed,
                size: 22,
              ),
              onPressed: _isDeleting ? null : _confirmAndDelete,
            ),
          ],
          bottomActionBar: canEdit
              ? TeduhBottomActionBar.outlined(
                  label: 'Edit My Story',
                  onPressed: _goToEdit,
                )
              : null,
          body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              24,
              8,
              24,
              24 + (canEdit ? 0 : bottomInset),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Day #${widget.dayNumber}',
                  style: textTheme.headlineMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  _currentDiary.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: AppColors.mutedText,
                  ),
                ),
                const SizedBox(height: 14),

                if (!canEdit) ...[
                  DefaultCard(
                    backgroundColor: AppColors.sand.withValues(alpha: 0.35),
                    hasShadow: false,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    leading: const Icon(
                      Icons.lock_clock_outlined,
                      color: AppColors.forestGreen,
                      size: 20,
                    ),
                    subtitle:
                        'Batas waktu penyuntingan (pukul 23:59 pada ${_currentDiary.formattedCreatedDate}) telah berakhir.',
                    subtitleColor: AppColors.forestGreen,
                  ),
                  const SizedBox(height: 16),
                ] else
                  const SizedBox(height: 4),

                ..._currentDiary.details.asMap().entries.map((entry) {
                  final index = entry.key;
                  final detail = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: DiaryAspectCard(
                      aspectNumber: index + 1,
                      aspect: detail.aspect,
                      isReadOnly: true,
                      readOnlyText: detail.content,
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
