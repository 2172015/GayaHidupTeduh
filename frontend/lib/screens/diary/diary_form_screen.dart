import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/diary.dart';
import '../../models/diary_aspect.dart';
import '../../services/diary_service.dart';
import '../../widgets/common/teduh_bottom_action_bar.dart';
import '../../widgets/common/teduh_loading_overlay.dart';
import 'widgets/diary_aspect_card.dart';

class DiaryFormScreen extends StatefulWidget {
  final String userId;
  final DiaryService diaryService;
  final int? dayNumber;
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
  final _titleController = TextEditingController();
  late final Map<DiaryAspect, TextEditingController> _aspectControllers;

  bool _isSaving = false;

  bool get _isEditing => widget.existingDiary != null;

  @override
  void initState() {
    super.initState();
    _aspectControllers = {
      for (final aspect in DiaryAspect.values) aspect: TextEditingController(),
    };

    if (_isEditing) {
      final diary = widget.existingDiary!;
      _titleController.text = diary.title;
      for (final aspect in DiaryAspect.values) {
        _aspectControllers[aspect]!.text = diary.contentFor(aspect) ?? '';
      }
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
      final updated = await widget.diaryService.updateDiary(
        widget.existingDiary!.copyWith(
          title: title,
          godContent: _aspectControllers[DiaryAspect.god]!.text,
          belovedContent: _aspectControllers[DiaryAspect.beloved]!.text,
          feelingContent: _aspectControllers[DiaryAspect.feeling]!.text,
          lifestyleContent: _aspectControllers[DiaryAspect.lifestyle]!.text,
          passionContent: _aspectControllers[DiaryAspect.passion]!.text,
        ),
      );
      if (!mounted) return;
      Navigator.pop(context, updated);
    } else {
      await widget.diaryService.createDiary(
        userId: widget.userId,
        title: title,
        godContent: _aspectControllers[DiaryAspect.god]!.text,
        belovedContent: _aspectControllers[DiaryAspect.beloved]!.text,
        feelingContent: _aspectControllers[DiaryAspect.feeling]!.text,
        lifestyleContent: _aspectControllers[DiaryAspect.lifestyle]!.text,
        passionContent: _aspectControllers[DiaryAspect.passion]!.text,
      );
      if (!mounted) return;
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TeduhLoadingOverlay(
      isLoading: _isSaving,
      message: _isEditing ? 'Menyimpan perubahan...' : 'Menyimpan ceritamu...',
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
                // Header: Back + Me & My Everyday Story
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 24, 4),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppColors.forestGreen,
                          size: 20,
                        ),
                        onPressed: () => Navigator.pop(context),
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
                      const SizedBox(width: 28),
                    ],
                  ),
                ),

                // Form Scrollable
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isEditing
                              ? 'Day #${widget.dayNumber ?? 1}'
                              : 'New Page',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.forestGreen,
                          ),
                        ),
                        const SizedBox(height: 6),

                        TextField(
                          controller: _titleController,
                          textCapitalization: TextCapitalization.sentences,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF383329),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Page Title',
                            hintStyle: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                              color: AppColors.forestGreen.withValues(
                                alpha: 0.4,
                              ),
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
                        const SizedBox(height: 20),

                        ...DiaryAspect.values.map((aspect) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: DiaryAspectCard(
                              aspect: aspect,
                              isReadOnly: false,
                              controller: _aspectControllers[aspect],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),

                // Bottom Sticky Bar
                TeduhBottomActionBar.primary(
                  label: _isEditing ? 'Save Changes' : 'Save My Story',
                  isDisabled: _isSaving,
                  onPressed: _saveDiary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
