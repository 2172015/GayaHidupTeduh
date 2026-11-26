class CounselorNote {
  final String id;
  final DateTime date;
  final String content;

  const CounselorNote({
    required this.id,
    required this.date,
    required this.content,
  });

  String get formattedDate {
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
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
