import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/mail_thread.dart';
import '../../services/mailbox_service.dart';
import 'widgets/mail_composer_bar.dart';
import 'widgets/mail_message_bubble_card.dart';

class MailThreadScreen extends StatefulWidget {
  final MailThread thread;
  final MailboxService mailboxService;

  const MailThreadScreen({
    super.key,
    required this.thread,
    required this.mailboxService,
  });

  @override
  State<MailThreadScreen> createState() => _MailThreadScreenState();
}

class _MailThreadScreenState extends State<MailThreadScreen> {
  late MailThread _thread;
  final _replyController = TextEditingController();
  final List<String> _attachments = [];
  bool _isSending = false;

  static const List<String> _placeholderPool = [
    'assets/images/homepage/Streak1-png.png',
    'assets/images/homepage/Streak2-png.png',
    'assets/images/homepage/Streak3-png.png',
    'assets/images/homepage/Streak4-png.png',
    'assets/images/moodtracker/Tenang.png',
  ];

  @override
  void initState() {
    super.initState();
    _thread = widget.thread;
    widget.mailboxService.markThreadAsRead(_thread.id);
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  void _addSimulatedAttachment() {
    if (_attachments.length >= 5) return;
    setState(() {
      _attachments.add(
        _placeholderPool[_attachments.length % _placeholderPool.length],
      );
    });
  }

  Future<void> _sendReply() async {
    final text = _replyController.text.trim();
    if (text.isEmpty && _attachments.isEmpty) return;

    setState(() => _isSending = true);
    final updated = await widget.mailboxService.replyToThread(
      threadId: _thread.id,
      body: text.isEmpty ? '(Mengirim lampiran gambar)' : text,
      attachments: _attachments,
    );

    if (!mounted) return;
    setState(() {
      _thread = updated;
      _replyController.clear();
      _attachments.clear();
      _isSending = false;
    });
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
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 24, 0),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.forestGreen,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 6, 24, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _thread.subject,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.forestGreen,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Divider(
                      height: 1,
                      color: AppColors.forestGreen.withValues(alpha: 0.25),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
                  itemCount: _thread.messages.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    return MailMessageBubbleCard(
                      message: _thread.messages[index],
                    );
                  },
                ),
              ),
              MailComposerBar(
                controller: _replyController,
                hintText: 'Write a reply...',
                attachments: _attachments,
                onAddAttachment: _addSimulatedAttachment,
                onRemoveAttachment: (idx) =>
                    setState(() => _attachments.removeAt(idx)),
                onSend: _sendReply,
                isSending: _isSending,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
