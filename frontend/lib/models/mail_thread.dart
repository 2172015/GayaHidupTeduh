import 'mail_message.dart';

class MailThread {
  final String id;
  final String sessionId;
  final String counselorId;
  final String counselorName;
  final String subject;
  final List<MailMessage> messages;
  final bool isUnread;
  final bool isDraft;
  final String? draftBody;
  final List<String> draftAttachments;
  final DateTime updatedAt;

  const MailThread({
    required this.id,
    required this.sessionId,
    required this.counselorId,
    required this.counselorName,
    required this.subject,
    this.messages = const [],
    this.isUnread = false,
    this.isDraft = false,
    this.draftBody,
    this.draftAttachments = const [],
    required this.updatedAt,
  });

  String get previewText {
    if (isDraft) {
      return (draftBody != null && draftBody!.trim().isNotEmpty)
          ? draftBody!.trim()
          : '(Belum ada isi pesan)';
    }
    if (messages.isEmpty) return '';
    return messages.last.body;
  }

  String get formattedListTime {
    final now = DateTime.now();
    final isToday =
        updatedAt.year == now.year &&
        updatedAt.month == now.month &&
        updatedAt.day == now.day;

    if (isToday || isDraft) {
      final hour12 = updatedAt.hour == 0
          ? 12
          : (updatedAt.hour > 12 ? updatedAt.hour - 12 : updatedAt.hour);
      final minute = updatedAt.minute.toString().padLeft(2, '0');
      final period = updatedAt.hour >= 12 ? 'PM' : 'AM';
      return '${hour12.toString().padLeft(2, '0')}:$minute $period';
    }

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
    return '${months[updatedAt.month - 1]} ${updatedAt.day}';
  }

  MailThread copyWith({
    String? id,
    String? sessionId,
    String? counselorId,
    String? counselorName,
    String? subject,
    List<MailMessage>? messages,
    bool? isUnread,
    bool? isDraft,
    String? draftBody,
    List<String>? draftAttachments,
    DateTime? updatedAt,
  }) {
    return MailThread(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      counselorId: counselorId ?? this.counselorId,
      counselorName: counselorName ?? this.counselorName,
      subject: subject ?? this.subject,
      messages: messages ?? this.messages,
      isUnread: isUnread ?? this.isUnread,
      isDraft: isDraft ?? this.isDraft,
      draftBody: draftBody ?? this.draftBody,
      draftAttachments: draftAttachments ?? this.draftAttachments,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
