import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';

class BookingCalendarCard extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const BookingCalendarCard({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<BookingCalendarCard> createState() => _BookingCalendarCardState();
}

class _BookingCalendarCardState extends State<BookingCalendarCard> {
  late int _displayedYear;
  late int _displayedMonth;

  static const List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static const List<String> _weekdays = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
  ];

  @override
  void initState() {
    super.initState();
    _displayedYear = widget.selectedDate.year;
    _displayedMonth = widget.selectedDate.month;
  }

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(_displayedYear, _displayedMonth, 1);
    final leadingEmptyCells = firstDayOfMonth.weekday % 7; // Sunday = 0
    final daysInMonth = DateTime(_displayedYear, _displayedMonth + 1, 0).day;
    final totalCells = leadingEmptyCells + daysInMonth;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.forestGreen.withValues(alpha: 0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Dropdown Bulan & Tahun Pill
          Row(
            children: [
              _buildPillDropdown<int>(
                value: _displayedMonth,
                items: List.generate(
                  12,
                  (i) =>
                      DropdownMenuItem(value: i + 1, child: Text(_months[i])),
                ),
                onChanged: (val) {
                  if (val != null) setState(() => _displayedMonth = val);
                },
              ),
              const SizedBox(width: 10),
              _buildPillDropdown<int>(
                value: _displayedYear,
                items: [2026, 2027]
                    .map((y) => DropdownMenuItem(value: y, child: Text('$y')))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _displayedYear = val);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Header Nama Hari (Sun - Sat)
          Row(
            children: _weekdays
                .map(
                  (d) => Expanded(
                    child: Center(
                      child: Text(
                        d,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4F554B),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 10),

          // Grid Tanggal
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: totalCells,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 6,
              crossAxisSpacing: 4,
            ),
            itemBuilder: (context, index) {
              if (index < leadingEmptyCells) {
                return const SizedBox.shrink();
              }
              final day = index - leadingEmptyCells + 1;
              final cellDate = DateTime(_displayedYear, _displayedMonth, day);
              final isSelected =
                  cellDate.year == widget.selectedDate.year &&
                  cellDate.month == widget.selectedDate.month &&
                  cellDate.day == widget.selectedDate.day;

              return GestureDetector(
                onTap: () => widget.onDateSelected(cellDate),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? const Color(0xFFD6D8D3)
                        : Colors.transparent,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$day',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w400,
                      color: isSelected
                          ? const Color(0xFF1E1E1E)
                          : const Color(0xFF8C9087),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPillDropdown<T>({
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFD9DBD6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          icon: const SizedBox.shrink(),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF5A5E56),
          ),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
