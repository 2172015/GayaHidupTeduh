import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/navigation/app_navigator.dart';
import '../../models/diary.dart';
import '../../services/diary_service.dart';
import '../../widgets/navigation/bottom_navigation_bar.dart';
import 'diary_detail_screen.dart';
import 'diary_form_screen.dart';
import 'widgets/diary_card.dart';

class DiaryScreen extends StatefulWidget {
  final String userId;
  final DiaryService? diaryService;

  const DiaryScreen({super.key, this.userId = '278392', this.diaryService});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  late final DiaryService _diaryService;
  List<Diary> _diaries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _diaryService = widget.diaryService ?? MockDiaryService();
    _loadDiaries();
  }

  Future<void> _loadDiaries() async {
    setState(() => _isLoading = true);
    final items = await _diaryService.getDiaries(widget.userId);
    if (!mounted) return;
    setState(() {
      _diaries = items;
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

  Future<void> _openDetailPage(Diary diary, int dayNumber) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (_) => DiaryDetailScreen(
          dayNumber: dayNumber,
          diary: diary,
          diaryService: _diaryService,
        ),
      ),
    );
    if (changed == true) _loadDiaries();
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
          child: RefreshIndicator(
            color: AppColors.forestGreen,
            onRefresh: _loadDiaries,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Gaya Hidup Teduh',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF7D9378),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Me & My\nEveryday Story',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: AppColors.forestGreen,
                                height: 1.15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.pureWhite,
                          border: Border.all(
                            color: AppColors.forestGreen,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/profilepicture/pp1.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  const Text(
                    'Setiap cerita membimbingmu\nmelalui 5 aspek kehidupan',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.forestGreen,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: _openCreatePage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.sageGreen,
                        foregroundColor: AppColors.forestGreen,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'New Page',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.forestGreen,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 48),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.forestGreen,
                        ),
                      ),
                    )
                  else if (_diaries.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: AppColors.offWhite,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: AppColors.forestGreen.withValues(alpha: 0.2),
                        ),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.auto_stories_outlined,
                            size: 42,
                            color: AppColors.forestGreen,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Belum ada halaman cerita',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.forestGreen,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Ketuk tombol "New Page" di atas untuk mulai menulis ceritamu hari ini.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF383329),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _diaries.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final diary = _diaries[index];
                        final dayNumber = index + 1;
                        return DiaryCard(
                          dayNumber: dayNumber,
                          diary: diary,
                          onTap: () => _openDetailPage(diary, dayNumber),
                        );
                      },
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: TeduhBottomNav(
        currentIndex: 1,
        onTap: (index) => AppNavigator.onBottomNavTapped(
          context,
          currentIndex: 1,
          targetIndex: index,
        ),
      ),
    );
  }
}
