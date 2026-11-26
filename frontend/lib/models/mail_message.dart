class MailMessage {
  final String id;
  final String senderName;
  final String senderAvatarAsset;
  final bool isFromUser;
  final String body;
  final List<String> attachmentAssets;
  final DateTime sentAt;

  const MailMessage({
    required this.id,
    required this.senderName,
    required this.senderAvatarAsset,
    required this.isFromUser,
    required this.body,
    this.attachmentAssets = const [],
    required this.sentAt,
  });

  String get formattedTimestamp {
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
    final hour12 = sentAt.hour == 0
        ? 12
        : (sentAt.hour > 12 ? sentAt.hour - 12 : sentAt.hour);
    final minute = sentAt.minute.toString().padLeft(2, '0');
    final period = sentAt.hour >= 12 ? 'PM' : 'AM';
    return '${months[sentAt.month - 1]} ${sentAt.day}, ${hour12.toString().padLeft(2, '0')}:$minute $period';
  }
}
