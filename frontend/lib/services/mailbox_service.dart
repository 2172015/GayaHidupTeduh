import '../models/counseling_booking.dart';
import '../models/mail_message.dart';
import '../models/mail_thread.dart';

abstract class MailboxService {
  Future<List<MailThread>> getThreadsForSession(CounselingBooking booking);
  Future<List<MailThread>> getAllUnreadThreads();
  Future<void> markThreadAsRead(String threadId);
  Future<MailThread> replyToThread({
    required String threadId,
    required String body,
    List<String> attachments = const [],
  });
  Future<MailThread> sendNewMail({
    required CounselingBooking booking,
    required String subject,
    required String body,
    List<String> attachments = const [],
    String? existingDraftId,
  });
  Future<void> saveDraft({
    required CounselingBooking booking,
    required String subject,
    required String body,
    List<String> attachments = const [],
    String? existingDraftId,
  });
}

class MockMailboxService implements MailboxService {
  static final List<MailThread> _threads = [
    MailThread(
      id: 'mail-1',
      sessionId: '#CS-2089202612',
      counselorId: 'c2',
      counselorName: 'Clara Elson, Psikolog',
      subject: 'Weekly reflection checklist',
      isUnread: true,
      updatedAt: DateTime(2026, 11, 19, 10, 30),
      messages: [
        MailMessage(
          id: 'msg-1',
          senderName: 'Clara Elson, Psikolog',
          senderAvatarAsset: 'assets/images/profilepicture/pp2.png',
          isFromUser: false,
          body: "Hi User, I've completed the mindfulness reflection we discussed. I think the work that you have made is perfect.",
          sentAt: DateTime(2026, 11, 19, 10, 0),
        ),
        MailMessage(
          id: 'msg-2',
          senderName: 'You',
          senderAvatarAsset: 'assets/images/profilepicture/pp1.png',
          isFromUser: true,
          body: 'Hi Clara, thanks for the update, here is some of my reflections, can you check?',
          attachmentAssets: const [
            'assets/images/homepage/Streak3-png.png',
            'assets/images/homepage/Streak4-png.png',
          ],
          sentAt: DateTime(2026, 11, 19, 10, 6),
        ),
      ],
    ),
    MailThread(
      id: 'mail-2',
      sessionId: '#CS-2089202612',
      counselorId: 'c2',
      counselorName: 'Clara Elson, Psikolog',
      subject: 'Next Session Preparation',
      isUnread: true,
      updatedAt: DateTime(2026, 11, 19, 9, 15),
      messages: [
        MailMessage(
          id: 'msg-3',
          senderName: 'Clara Elson, Psikolog',
          senderAvatarAsset: 'assets/images/profilepicture/pp2.png',
          isFromUser: false,
          body: 'For the next session you can follow-up on my schedule. Please contact me if there is anything you want to discuss beforehand.',
          sentAt: DateTime(2026, 11, 19, 9, 15),
        ),
      ],
    ),
    MailThread(
      id: 'mail-3',
      sessionId: '#CS-2089202612',
      counselorId: 'c2',
      counselorName: 'Clara Elson, Psikolog',
      subject: 'Weekly reflection checklist',
      isDraft: true,
      draftBody: 'Hi, I would like to share my weekly reflection notes before our upcoming session...',
      updatedAt: DateTime(2026, 11, 19, 14, 39),
    ),
  ];

  @override
  Future<List<MailThread>> getThreadsForSession(
    CounselingBooking booking,
  ) async {
    await Future.delayed(const Duration(milliseconds: 220));
    final counselor = booking.primaryItem.counselor;
    return _threads
        .where(
          (t) =>
              t.sessionId == booking.sessionId || t.counselorId == counselor.id,
        )
        .toList();
  }

  @override
  Future<List<MailThread>> getAllUnreadThreads() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _threads.where((t) => t.isUnread && !t.isDraft).toList();
  }

  @override
  Future<void> markThreadAsRead(String threadId) async {
    final idx = _threads.indexWhere((t) => t.id == threadId);
    if (idx != -1 && _threads[idx].isUnread) {
      _threads[idx] = _threads[idx].copyWith(isUnread: false);
    }
  }

  @override
  Future<MailThread> replyToThread({
    required String threadId,
    required String body,
    List<String> attachments = const [],
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final idx = _threads.indexWhere((t) => t.id == threadId);
    final current = _threads[idx];
    final now = DateTime.now();

    final newMessage = MailMessage(
      id: 'msg-${now.millisecondsSinceEpoch}',
      senderName: 'You',
      senderAvatarAsset: 'assets/images/profilepicture/pp1.png',
      isFromUser: true,
      body: body.trim(),
      attachmentAssets: List<String>.from(attachments),
      sentAt: now,
    );

    final updated = current.copyWith(
      messages: [...current.messages, newMessage],
      isUnread: false,
      updatedAt: now,
    );
    _threads[idx] = updated;
    return updated;
  }

  @override
  Future<MailThread> sendNewMail({
    required CounselingBooking booking,
    required String subject,
    required String body,
    List<String> attachments = const [],
    String? existingDraftId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 350));
    final counselor = booking.primaryItem.counselor;
    final now = DateTime.now();

    if (existingDraftId != null) {
      _threads.removeWhere((t) => t.id == existingDraftId);
    }

    final created = MailThread(
      id: 'mail-${now.millisecondsSinceEpoch}',
      sessionId: booking.sessionId,
      counselorId: counselor.id,
      counselorName: counselor.name,
      subject: subject.trim(),
      isUnread: false,
      isDraft: false,
      updatedAt: now,
      messages: [
        MailMessage(
          id: 'msg-${now.millisecondsSinceEpoch}',
          senderName: 'You',
          senderAvatarAsset: 'assets/images/profilepicture/pp1.png',
          isFromUser: true,
          body: body.trim(),
          attachmentAssets: List<String>.from(attachments),
          sentAt: now,
        ),
      ],
    );

    _threads.insert(0, created);
    return created;
  }

  @override
  Future<void> saveDraft({
    required CounselingBooking booking,
    required String subject,
    required String body,
    List<String> attachments = const [],
    String? existingDraftId,
  }) async {
    final counselor = booking.primaryItem.counselor;
    final now = DateTime.now();
    final effectiveSubject = subject.trim().isEmpty
        ? '(Tanpa Subjek)'
        : subject.trim();

    if (existingDraftId != null) {
      final idx = _threads.indexWhere((t) => t.id == existingDraftId);
      if (idx != -1) {
        _threads[idx] = _threads[idx].copyWith(
          subject: effectiveSubject,
          draftBody: body.trim(),
          draftAttachments: List<String>.from(attachments),
          updatedAt: now,
        );
        return;
      }
    }

    _threads.add(
      MailThread(
        id: 'draft-${now.millisecondsSinceEpoch}',
        sessionId: booking.sessionId,
        counselorId: counselor.id,
        counselorName: counselor.name,
        subject: effectiveSubject,
        isDraft: true,
        draftBody: body.trim(),
        draftAttachments: List<String>.from(attachments),
        updatedAt: now,
      ),
    );
  }
}
