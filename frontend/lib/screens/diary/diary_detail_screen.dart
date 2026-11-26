import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/diary.dart';
import '../../models/diary_aspect.dart';
import '../../services/diary_service.dart';
import '../../widgets/common/teduh_confirm_dialog.dart';
import '../../widgets/common/teduh_loading_overlay.dart';
import '../../widgets/common/teduh_bottom_action_bar.dart';
import 'diary_form_screen.dart';
import 'widgets/diary_aspect_card.dart';

class DiaryDetailScreen extends StatefulWidget {
  final int dayNumber;
  final Diary diary;
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) Navigator.pop(context, _hasUpdated);
      },
      child: TeduhLoadingOverlay(
        isLoading: _isDeleting,
        message: 'Menghapus cerita...',
        child: Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.45, 1.0],
                colors: [
                  AppColors.offWhite,
                  AppColors.offWhite,
                  Color(0xFF9AB08A),
                ],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // Top Navigation Header (Back + Title + Delete)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: AppColors.forestGreen,
                            size: 20,
                          ),
                          onPressed: () => Navigator.pop(context, _hasUpdated),
                        ),
                        const Expanded(
                          child: Text(
                            'Me & My Everyday Story',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: AppColors.forestGreen,
                            ),
                          ),
                        ),
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
                    ),
                  ),

                  // Konten Scrollable
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Day #${widget.dayNumber}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.forestGreen,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _currentDiary.title,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF7A7E75),
                            ),
                          ),
                          const SizedBox(height: 18),

                          ...DiaryAspect.values.map((aspect) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: DiaryAspectCard(
                                aspect: aspect,
                                isReadOnly: true,
                                readOnlyText: _currentDiary.contentFor(aspect),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Sticky Bar
                  TeduhBottomActionBar.outlined(
                    label: 'Edit My Story',
                    onPressed: _goToEdit,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
