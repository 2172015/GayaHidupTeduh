/// Halaman utama daftar diary pada fitur Me & My Everyday Story.
library;

import 'package:flutter/material.dart';

import '../../core/navigation/app_navigator.dart';
import '../../core/theme/app_colors.dart';
import '../../models/diary.dart';
import '../../services/diary_service.dart';
import '../../widgets/cards/default_card.dart';
import '../../widgets/common/teduh_page_header.dart';
import '../../widgets/common/teduh_scaffold.dart';
import '../../widgets/navigation/bottom_navigation_bar.dart';
import 'diary_archive_screen.dart';
import 'diary_detail_screen.dart';
import 'diary_form_screen.dart';
import 'widgets/diary_card.dart';

/// Layar tab kedua yang menampilkan daftar halaman cerita pada bulan berjalan.
class DiaryScreen extends StatefulWidget {
  /// ID pengguna aktif.
  final String userId;

  /// Layanan data diary.
  final DiaryService? diaryService;

  const DiaryScreen({super.key, this.userId = '278392', this.diaryService});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  late final DiaryService _diaryService;
  List<Diary> _currentMonthDiaries = [];
  int _archivedCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _diaryService = widget.diaryService ?? MockDiaryService();
    _loadDiaries();
  }

  Future<void> _loadDiaries() async {
    setState(() => _isLoading = true);
    final allDiaries = await _diaryService.getDiaries(widget.userId);

    // Pisahkan cerita bulan ini (terbaru di atas) dan hitung jumlah arsip
    final thisMonth = allDiaries.where((d) => d.isCurrentMonth).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final archivedTotal = allDiaries.where((d) => !d.isCurrentMonth).length;

    if (!mounted) return;
    setState(() {
      _currentMonthDiaries = thisMonth;
      _archivedCount = archivedTotal;
      _isLoading = false;
    });
  }

  Future<void> _openCreatePage() async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (_) =>
            DiaryFormScreen(userId: widget.userId, diaryService: _diaryService),
      ),
    );
    if (created == true) _loadDiaries();
  }

  Future<void> _openArchivePage() async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (_) => DiaryArchiveScreen(
          userId: widget.userId,
          diaryService: _diaryService,
        ),
      ),
    );
    if (changed == true) _loadDiaries();
  }

  Future<void> _openDetailPage(Diary diary) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (_) => DiaryDetailScreen(
          dayNumber: diary.dayNumber,
          diary: diary,
          diaryService: _diaryService,
        ),
      ),
    );
    if (changed == true) _loadDiaries();
  }

  @override
  Widget build(BuildContext context) {
    return TeduhScaffold(
      bottomNavigationBar: TeduhBottomNav(
        currentIndex: 1,
        onTap: (index) => AppNavigator.onBottomNavTapped(
          context,
          currentIndex: 1,
          targetIndex: index,
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.forestGreen,
        onRefresh: _loadDiaries,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TeduhPageHeader(
                title: 'Me & My\nEveryday Story',
                subtitle:
                    'Setiap cerita membimbingmu\nmelalui 5 aspek kehidupan',
              ),
              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: _openCreatePage,
                  child: const Text('New Page'),
                ),
              ),
              const SizedBox(height: 18),

              // Baris Header Bulan Berjalan + Tombol Arsip
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      Diary.currentMonthYearLabel,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.forestGreen,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _openArchivePage,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.forestGreen,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      backgroundColor: AppColors.pureWhite.withValues(
                        alpha: 0.7,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: BorderSide(
                          color: AppColors.forestGreen.withValues(alpha: 0.25),
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.archive_outlined, size: 18),
                    label: Text(
                      _archivedCount > 0 ? 'Arsip ($_archivedCount)' : 'Arsip',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 48),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.forestGreen,
                    ),
                  ),
                )
              else if (_currentMonthDiaries.isEmpty)
                DefaultCard(
                  padding: const EdgeInsets.all(28),
                  hasShadow: false,
                  child: Column(
                    children: [
                      const Icon(
                        Icons.auto_stories_outlined,
                        size: 42,
                        color: AppColors.forestGreen,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Belum ada cerita di ${Diary.currentMonthYearLabel}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.forestGreen,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Ketuk tombol "New Page" di atas untuk menulis hari ini, atau buka "Arsip" untuk cerita bulan sebelumnya.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.bodyText,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _currentMonthDiaries.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final diary = _currentMonthDiaries[index];
                    return DiaryCard(
                      dayNumber: diary.dayNumber,
                      diary: diary,
                      onTap: () => _openDetailPage(diary),
                    );
                  },
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
