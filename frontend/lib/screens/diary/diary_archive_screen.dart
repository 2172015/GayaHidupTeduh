/// Halaman arsip untuk menelusuri cerita diary dari bulan-bulan sebelumnya.
library;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/diary.dart';
import '../../services/diary_service.dart';
import '../../widgets/cards/default_card.dart';
import '../../widgets/common/teduh_scaffold.dart';
import 'diary_detail_screen.dart';
import 'widgets/diary_card.dart';

/// Layar arsip yang menampilkan daftar [Diary] di luar bulan berjalan,
/// dilengkapi pencarian judul dan dropdown filter berdasarkan bulan.
class DiaryArchiveScreen extends StatefulWidget {
  /// ID pengguna aktif.
  final String userId;

  /// Layanan data diary.
  final DiaryService diaryService;

  const DiaryArchiveScreen({
    super.key,
    required this.userId,
    required this.diaryService,
  });

  @override
  State<DiaryArchiveScreen> createState() => _DiaryArchiveScreenState();
}

class _DiaryArchiveScreenState extends State<DiaryArchiveScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<Diary> _archivedDiaries = [];
  String? _selectedMonthKey;
  String _searchQuery = '';
  bool _isLoading = true;
  bool _hasChanged = false;

  @override
  void initState() {
    super.initState();
    _loadArchivedDiaries();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadArchivedDiaries() async {
    setState(() => _isLoading = true);
    final allDiaries = await widget.diaryService.getDiaries(widget.userId);

    // Ambil hanya diary di luar bulan berjalan, terurut terbaru di atas
    final archived = allDiaries.where((d) => !d.isCurrentMonth).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    if (!mounted) return;
    setState(() {
      _archivedDiaries = archived;
      if (_selectedMonthKey != null &&
          !archived.any((d) => d.monthYearKey == _selectedMonthKey)) {
        _selectedMonthKey = null;
      }
      _isLoading = false;
    });
  }

  Future<void> _openDetailPage(Diary diary) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (_) => DiaryDetailScreen(
          dayNumber: diary.dayNumber,
          diary: diary,
          diaryService: widget.diaryService,
        ),
      ),
    );
    if (changed == true) {
      _hasChanged = true;
      await _loadArchivedDiaries();
    }
  }

  /// Daftar pasangan (monthYearKey, label bulan-tahun) unik terurut terbaru.
  List<MapEntry<String, String>> get _availableMonths {
    final seen = <String, String>{};
    for (final diary in _archivedDiaries) {
      seen.putIfAbsent(diary.monthYearKey, () => diary.formattedFullMonthYear);
    }
    return seen.entries.toList();
  }

  List<Diary> get _filteredDiaries {
    final query = _searchQuery.trim().toLowerCase();
    return _archivedDiaries.where((diary) {
      final matchesMonth =
          _selectedMonthKey == null || diary.monthYearKey == _selectedMonthKey;
      final matchesTitle =
          query.isEmpty || diary.title.toLowerCase().contains(query);
      return matchesMonth && matchesTitle;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final availableMonths = _availableMonths;
    final filtered = _filteredDiaries;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) Navigator.pop(context, _hasChanged);
      },
      child: TeduhScaffold(
        title: 'Arsip Cerita',
        onBackPressed: () => Navigator.pop(context, _hasChanged),
        body: Column(
          children: [
            // Kolom Pencarian Judul
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 10),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _searchQuery = value),
                style: const TextStyle(fontSize: 14, color: AppColors.bodyText),
                decoration: InputDecoration(
                  hintText: 'Cari berdasarkan judul cerita...',
                  hintStyle: const TextStyle(
                    fontSize: 13.5,
                    color: AppColors.mutedText,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppColors.forestGreen,
                    size: 21,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          tooltip: 'Hapus pencarian',
                          icon: const Icon(
                            Icons.close_rounded,
                            color: AppColors.mutedText,
                            size: 19,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: AppColors.pureWhite,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(
                      color: AppColors.forestGreen.withValues(alpha: 0.25),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(
                      color: AppColors.forestGreen.withValues(alpha: 0.25),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(
                      color: AppColors.forestGreen,
                      width: 1.4,
                    ),
                  ),
                ),
              ),
            ),

            // Dropdown Filter Bulan (Default: null / Semua Bulan)
            if (availableMonths.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 10),
                child: _buildMonthDropdown(availableMonths),
              ),

            // Daftar Arsip
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.forestGreen,
                      ),
                    )
                  : filtered.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: DefaultCard(
                          padding: const EdgeInsets.all(28),
                          hasShadow: false,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.inventory_2_outlined,
                                size: 40,
                                color: AppColors.forestGreen,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _archivedDiaries.isEmpty
                                    ? 'Belum ada cerita di arsip'
                                    : 'Cerita tidak ditemukan',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.forestGreen,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _archivedDiaries.isEmpty
                                    ? 'Cerita dari bulan-bulan sebelumnya akan otomatis tersimpan di sini.'
                                    : 'Coba ubah kata kunci pencarian atau pilih bulan lain.',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.bodyText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.fromLTRB(
                        24,
                        6,
                        24,
                        24 + MediaQuery.paddingOf(context).bottom,
                      ),
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final diary = filtered[index];
                        return DiaryCard(
                          dayNumber: diary.dayNumber,
                          diary: diary,
                          onTap: () => _openDetailPage(diary),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthDropdown(List<MapEntry<String, String>> availableMonths) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.forestGreen.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.calendar_month_outlined,
            color: AppColors.forestGreen,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String?>(
                value: _selectedMonthKey,
                isExpanded: true,
                dropdownColor: AppColors.pureWhite,
                borderRadius: BorderRadius.circular(16),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.forestGreen,
                ),
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.bodyText,
                ),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text(
                      'Semua Bulan',
                      style: TextStyle(
                        fontSize: 13.5,
                        color: AppColors.mutedText,
                      ),
                    ),
                  ),
                  ...availableMonths.map(
                    (entry) => DropdownMenuItem<String?>(
                      value: entry.key,
                      child: Text(
                        entry.value,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.forestGreen,
                        ),
                      ),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() => _selectedMonthKey = value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
