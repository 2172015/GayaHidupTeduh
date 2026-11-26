import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../models/mood_record.dart';
import '../../services/mood_service.dart';
import 'mood_tracker_screen.dart';
import 'widgets/mood_emotion_breakdown_card.dart';
import 'widgets/mood_week_calendar.dart';

class MoodHistoryScreen extends StatefulWidget {
  final String userId;
  final MoodService? moodService;

  const MoodHistoryScreen({
    super.key,
    this.userId = '278392',
    this.moodService,
  });

  @override
  State<MoodHistoryScreen> createState() => _MoodHistoryScreenState();
}

class _MoodHistoryScreenState extends State<MoodHistoryScreen> {
  late final MoodService _moodService;

  DateTime _selectedDate = DateTime.now();
  MoodRecord? _currentRecord;
  int _streakDays = 30;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _moodService = widget.moodService ?? MockMoodService();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final record = await _moodService.getRecordByDate(
      widget.userId,
      _selectedDate,
    );
    final streak = await _moodService.getCurrentStreak(widget.userId);
    if (!mounted) return;
    setState(() {
      _currentRecord = record;
      _streakDays = streak;
      _isLoading = false;
    });
  }

  String get _streakStageTitle {
    if (_streakDays < 7) return 'Tahap 1: Tunas Harapan';
    if (_streakDays < 14) return 'Tahap 2: Pohon Muda';
    if (_streakDays < 21) return 'Tahap 3: Pohon Rindang';
    return 'Tahap 4: Pohon Bercahaya';
  }

  double get _streakProgress {
    const target = 35.0;
    return (_streakDays / target).clamp(0.0, 1.0);
  }

  Future<void> _openCheckInOrEdit() async {
    final saved = await Navigator.push<MoodRecord>(
      context,
      MaterialPageRoute<MoodRecord>(
        builder: (_) => MoodTrackerScreen(
          userId: widget.userId,
          targetDate: _selectedDate,
          initialRecord: _currentRecord,
          moodService: _moodService,
        ),
      ),
    );

    if (saved != null) {
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.48, 1.0],
            colors: [AppColors.offWhite, AppColors.offWhite, Color(0xFF9AB08A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar
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
                        'Riwayat Mood',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.forestGreen,
                        ),
                      ),
                    ),
                    const SizedBox(width: 28),
                  ],
                ),
              ),

              // Strip Kalender Mingguan
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: MoodWeekCalendar(
                  selectedDate: _selectedDate,
                  onDateSelected: (newDate) {
                    setState(() => _selectedDate = newDate);
                    _loadData();
                  },
                ),
              ),
              const SizedBox(height: 12),

              // Konten Riwayat
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.forestGreen,
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
                        child: Column(
                          children: [
                            _buildDominantCard(),
                            const SizedBox(height: 16),
                            if (_currentRecord != null) ...[
                              MoodEmotionBreakdownCard(record: _currentRecord!),
                              const SizedBox(height: 16),
                            ],
                            _buildStreakCard(),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDominantCard() {
    final record = _currentRecord;
    final dominant = record?.dominantMood;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.forestGreen.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            dominant != null
                ? dominant.assetPath
                : 'assets/images/homepage/Streak4-png.png',
            width: 105,
            height: 115,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record?.formattedDate ??
                      MoodRecord(
                        moodId: '',
                        userId: '',
                        date: _selectedDate,
                        scores: const {},
                        createdAt: _selectedDate,
                        updatedAt: _selectedDate,
                      ).formattedDate,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF383329),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dominant != null
                      ? 'Dominan: ${dominant.label}'
                      : 'Belum ada Check-In',
                  style: const TextStyle(
                    fontSize: 17.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: _openCheckInOrEdit,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.forestGreen,
                    side: const BorderSide(
                      color: AppColors.forestGreen,
                      width: 1.4,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    minimumSize: const Size(0, 34),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    record != null ? 'Edit Check-In' : 'Isi Check-In',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.sageGreen,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.water_drop_rounded,
            size: 62,
            color: Color(0xFF6BAEE6),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$_streakDays Hari Streak',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _streakStageTitle,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: _streakProgress,
                    minHeight: 10,
                    backgroundColor: const Color(0xFF839A6C),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.forestGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
