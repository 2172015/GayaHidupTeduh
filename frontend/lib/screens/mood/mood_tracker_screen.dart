import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../models/mood_dimension.dart';
import '../../models/mood_record.dart';
import '../../services/mood_service.dart';
import '../../widgets/common/teduh_bottom_action_bar.dart';
import '../../widgets/common/teduh_loading_overlay.dart';
import 'widgets/mood_level_indicator.dart';
import 'widgets/mood_score_slider.dart';

class MoodTrackerScreen extends StatefulWidget {
  final String userId;
  final DateTime? targetDate;
  final MoodRecord? initialRecord;
  final MoodService? moodService;

  const MoodTrackerScreen({
    super.key,
    this.userId = '278392',
    this.targetDate,
    this.initialRecord,
    this.moodService,
  });

  @override
  State<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  late final MoodService _moodService;
  late final Map<MoodDimension, int> _scores;

  int _currentStep = 0;
  bool _isSaving = false;

  List<MoodDimension> get _steps => MoodDimension.values;
  MoodDimension get _currentDimension => _steps[_currentStep];
  bool get _isLastStep => _currentStep == _steps.length - 1;

  @override
  void initState() {
    super.initState();
    _moodService = widget.moodService ?? MockMoodService();
    _scores = {
      for (final dim in _steps) dim: widget.initialRecord?.scoreFor(dim) ?? 5,
    };
  }

  void _handleBack() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _handleNextOrSave() async {
    if (!_isLastStep) {
      setState(() => _currentStep += 1);
      return;
    }

    setState(() => _isSaving = true);
    final savedRecord = await _moodService.saveCheckIn(
      userId: widget.userId,
      date: widget.targetDate ?? widget.initialRecord?.date ?? DateTime.now(),
      scores: _scores,
    );

    if (!mounted) return;
    Navigator.pop(context, savedRecord);
  }

  @override
  Widget build(BuildContext context) {
    final currentScore = _scores[_currentDimension]!;

    return PopScope(
      canPop: _currentStep == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _currentStep > 0) {
          setState(() => _currentStep -= 1);
        }
      },
      child: TeduhLoadingOverlay(
        isLoading: _isSaving,
        message: 'Menyimpan suasana hatimu...',
        child: Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.48, 1.0],
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
                  // Top Bar: Back + Title + Step Counter
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 20, 4),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: AppColors.forestGreen,
                            size: 20,
                          ),
                          onPressed: _handleBack,
                        ),
                        const Expanded(
                          child: Text(
                            'Mood Tracker',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.forestGreen,
                            ),
                          ),
                        ),
                        Text(
                          '${_currentStep + 1}/${_steps.length}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.forestGreen.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Konten Utama
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            _currentDimension.question,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                              color: AppColors.forestGreen,
                            ),
                          ),

                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 260),
                            child: Image.asset(
                              _currentDimension.assetPath,
                              key: ValueKey(_currentDimension.assetPath),
                              height: 220,
                              fit: BoxFit.contain,
                            ),
                          ),

                          MoodScoreSlider(
                            value: currentScore,
                            emotionLabel: _currentDimension.label,
                            onChanged: (newScore) {
                              setState(() {
                                _scores[_currentDimension] = newScore;
                              });
                            },
                          ),

                          MoodLevelIndicator(
                            averageScore: MoodDimension.calculateOverallAverage(
                              _scores,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Sticky Bar
                  TeduhBottomActionBar.primary(
                    label: _isLastStep ? 'Save' : 'Next',
                    isDisabled: _isSaving,
                    onPressed: _handleNextOrSave,
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
