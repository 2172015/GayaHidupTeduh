class MailItem {
  final String id;
  final String sender;
  final String subject;
  final String body;
  final String time;
  final bool isRead;

  const MailItem({
    this.id = '',
    required this.sender,
    required this.subject,
    this.body = '',
    required this.time,
    this.isRead = false,
  });

  /// Siap dipakai nanti saat integrasi dengan backend Laravel
  factory MailItem.fromJson(Map<String, dynamic> json) {
    return MailItem(
      id: json['id']?.toString() ?? '',
      sender: json['sender'] ?? 'Konselor',
      subject: json['subject'] ?? '',
      body: json['body'] ?? '',
      time: json['time'] ?? '',
      isRead: json['is_read'] ?? false,
    );
  }
}