import 'counselor.dart';

class BookingSlotItem {
  final String id;
  final Counselor counselor;
  final DateTime date;
  final String timeSlot;

  const BookingSlotItem({
    required this.id,
    required this.counselor,
    required this.date,
    required this.timeSlot,
  });

  int get fee => counselor.feePerSession;

  String get formattedSchedule {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    final dayName = weekdays[date.weekday - 1];
    final monthName = months[date.month - 1];
    return '$dayName | $monthName ${date.day}, ${date.year} ($timeSlot)';
  }

  String get formattedShortDateTime {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year} • $timeSlot';
  }

  String get formattedDateOnly {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
