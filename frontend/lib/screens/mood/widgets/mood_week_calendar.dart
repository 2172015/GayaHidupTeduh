import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';

class MoodWeekCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const MoodWeekCalendar({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  static const List<String> _shortWeekdays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final days = List.generate(
      5,
      (i) => selectedDate.add(Duration(days: i - 2)),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(
            Icons.chevron_left_rounded,
            color: AppColors.forestGreen.withValues(alpha: 0.45),
          ),
          onPressed: () =>
              onDateSelected(selectedDate.subtract(const Duration(days: 1))),
        ),
        ...days.map((day) {
          final isSelected = _isSameDay(day, selectedDate);
          return GestureDetector(
            onTap: () => onDateSelected(day),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.sageGreen : Colors.transparent,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _shortWeekdays[day.weekday - 1],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected
                          ? const Color(0xFF1E1E1E)
                          : const Color(0xFF9E9E9E),
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    '${day.day}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: isSelected
                          ? const Color(0xFF1E1E1E)
                          : const Color(0xFF9E9E9E),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        IconButton(
          icon: Icon(
            Icons.chevron_right_rounded,
            color: AppColors.forestGreen.withValues(alpha: 0.45),
          ),
          onPressed: () =>
              onDateSelected(selectedDate.add(const Duration(days: 1))),
        ),
      ],
    );
  }
}
