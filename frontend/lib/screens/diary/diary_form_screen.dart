/// Halaman formulir pembuatan dan penyuntingan halaman cerita diary.
library;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/diary.dart';
import '../../models/diary_aspect.dart';
import '../../services/diary_service.dart';
import '../../widgets/common/teduh_bottom_action_bar.dart';
import '../../widgets/common/teduh_loading_overlay.dart';
import '../../widgets/common/teduh_scaffold.dart';
import 'widgets/diary_aspect_card.dart';

/// Layar formulir untuk membuat halaman [Diary] baru atau menyunting halaman lama.
class DiaryFormScreen extends StatefulWidget {
  /// ID pengguna aktif.
  final String userId;

  /// Layanan data diary.
  final DiaryService diaryService;

  /// Nomor urut hari (diisi saat mode penyuntingan).
  final int? dayNumber;

  /// Halaman diary lama jika layar dibuka dalam mode penyuntingan.
  final Diary? existingDiary;

  const DiaryFormScreen({
    super.key,
    required this.userId,
    required this.diaryService,
    this.dayNumber,
    this.existingDiary,
  });

  @override
  State<DiaryFormScreen> createState() => _DiaryFormScreenState();
}

class _DiaryFormScreenState extends State<DiaryFormScreen> {
  static const int _maxTitleLength = 80;

  final _titleController = TextEditingController();
  final Map<String, TextEditingController> _aspectControllers = {};

  List<DiaryAspect> _aspects = [];
  bool _isLoadingAspects = true;
  bool _isSaving = false;

  bool get _isEditing => widget.existingDiary != null;

  @override
  void initState() {
    super.initState();
    _initFormFields();
  }

  Future<void> _initFormFields() async {
    if (_isEditing) {
      final diary = widget.existingDiary!;
      _titleController.text = diary.title;
      final lockedAspects = <DiaryAspect>[];

      for (final detail in diary.details) {
        lockedAspects.add(detail.aspect);
        _aspectControllers[detail.aspectId] = TextEditingController(
          text: detail.content ?? '',
        );
      }

      if (!mounted) return;
      setState(() {
        _aspects = lockedAspects;
        _isLoadingAspects = false;
      });
    } else {
      final activeAspects = await widget.diaryService.getFormAspects();
      for (final aspect in activeAspects) {
        _aspectControllers[aspect.aspectId] = TextEditingController();
      }

      if (!mounted) return;
      setState(() {
        _aspects = activeAspects;
        _isLoadingAspects = false;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (final controller in _aspectControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _saveDiary() async {
    if (_isEditing && !widget.existingDiary!.canEdit) {
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

    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Judul halaman cerita tidak boleh kosong.'),
          backgroundColor: AppColors.errorRed,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    if (_isEditing) {
      final now = DateTime.now();
      final existing = widget.existingDiary!;
      final updatedDetails = existing.details.map((detail) {
        final rawText = _aspectControllers[detail.aspectId]?.text.trim();
        return detail.copyWith(
          content: (rawText == null || rawText.isEmpty) ? null : rawText,
          updatedAt: now,
        );
      }).toList();

      final updated = await widget.diaryService.updateDiary(
        existing.copyWith(
          title: title,
          details: updatedDetails,
          updatedAt: now,
        ),
      );
      if (!mounted) return;
      Navigator.pop(context, updated);
    } else {
      final contentMap = <String, String>{
        for (final aspect in _aspects)
          aspect.aspectId: _aspectControllers[aspect.aspectId]?.text ?? '',
      };

      await widget.diaryService.createDiary(
        userId: widget.userId,
        title: title,
        aspects: _aspects,
        aspectContents: contentMap,
      );
      if (!mounted) return;
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return TeduhLoadingOverlay(
      isLoading: _isSaving,
      message: _isEditing ? 'Menyimpan perubahan...' : 'Menyimpan ceritamu...',
      child: TeduhScaffold(
        title: 'Me & My Everyday Story',
        bottomActionBar: TeduhBottomActionBar.primary(
          label: _isEditing ? 'Save Changes' : 'Save My Story',
          isDisabled: _isSaving || _isLoadingAspects,
          onPressed: _saveDiary,
        ),
        body: _isLoadingAspects
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.forestGreen),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isEditing ? 'Day #${widget.dayNumber ?? 1}' : 'New Page',
                      style: textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 6),

                    TextField(
                      controller: _titleController,
                      maxLength: _maxTitleLength,
                      textCapitalization: TextCapitalization.sentences,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: AppColors.bodyText,
                      ),
                      buildCounter:
                          (
                            context, {
                            required currentLength,
                            required isFocused,
                            required maxLength,
                          }) {
                            final limit = maxLength ?? _maxTitleLength;
                            final isNearLimit = currentLength >= (limit * 0.9);
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '$currentLength/$limit',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: isNearLimit
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: isNearLimit
                                        ? AppColors.errorRed
                                        : AppColors.mutedText,
                                  ),
                                ),
                              ),
                            );
                          },
                      decoration: InputDecoration(
                        hintText: 'Page Title',
                        hintStyle: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: AppColors.forestGreen.withValues(alpha: 0.4),
                        ),
                        filled: false,
                        contentPadding: const EdgeInsets.only(bottom: 8),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.forestGreen.withValues(
                              alpha: 0.35,
                            ),
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.forestGreen.withValues(
                              alpha: 0.35,
                            ),
                          ),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.forestGreen,
                            width: 1.5,
                          ),
                        ),
                        errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.errorRed),
                        ),
                        focusedErrorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.errorRed),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    ..._aspects.asMap().entries.map((entry) {
                      final index = entry.key;
                      final aspect = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: DiaryAspectCard(
                          aspectNumber: index + 1,
                          aspect: aspect,
                          isReadOnly: false,
                          controller: _aspectControllers[aspect.aspectId],
                        ),
                      );
                    }),
                  ],
                ),
              ),
      ),
    );
  }
}
