import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../models/counseling_booking.dart';
import '../../models/mail_thread.dart';
import '../../services/mailbox_service.dart';
import '../../widgets/common/teduh_loading_overlay.dart';
import 'widgets/mail_composer_bar.dart';

class NewMailScreen extends StatefulWidget {
  final CounselingBooking booking;
  final MailboxService mailboxService;
  final MailThread? existingDraft;

  const NewMailScreen({
    super.key,
    required this.booking,
    required this.mailboxService,
    this.existingDraft,
  });

  @override
  State<NewMailScreen> createState() => _NewMailScreenState();
}

class _NewMailScreenState extends State<NewMailScreen> {
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();
  final List<String> _attachments = [];
  bool _isSending = false;
  bool _isHandlingBack = false;

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
    final draft = widget.existingDraft;
    if (draft != null) {
      _subjectController.text = draft.subject == '(Tanpa Subjek)'
          ? ''
          : draft.subject;
      _bodyController.text = draft.draftBody ?? '';
      _attachments.addAll(draft.draftAttachments);
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  bool get _hasUnsentContent =>
      _subjectController.text.trim().isNotEmpty ||
      _bodyController.text.trim().isNotEmpty ||
      _attachments.isNotEmpty;

  Future<void> _handleBackAndAutoSaveDraft() async {
    if (_isHandlingBack) return;
    _isHandlingBack = true;

    if (_hasUnsentContent) {
      await widget.mailboxService.saveDraft(
        booking: widget.booking,
        subject: _subjectController.text,
        body: _bodyController.text,
        attachments: _attachments,
        existingDraftId: widget.existingDraft?.id,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pesan otomatis disimpan sebagai Draft.'),
          backgroundColor: AppColors.forestGreen,
        ),
      );
      Navigator.pop(context, true);
    } else {
      Navigator.pop(context, false);
    }
  }

  void _addSimulatedAttachment() {
    if (_attachments.length >= 5) return;
    setState(() {
      _attachments.add(
        _placeholderPool[_attachments.length % _placeholderPool.length],
      );
    });
  }

  Future<void> _sendMail() async {
    final subject = _subjectController.text.trim();
    final body = _bodyController.text.trim();

    if (subject.isEmpty || (body.isEmpty && _attachments.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Subjek dan isi surat tidak boleh kosong.'),
          backgroundColor: AppColors.errorRed,
        ),
      );
      return;
    }

    setState(() => _isSending = true);
    await widget.mailboxService.sendNewMail(
      booking: widget.booking,
      subject: subject,
      body: body.isEmpty ? '(Mengirim lampiran gambar)' : body,
      attachments: _attachments,
      existingDraftId: widget.existingDraft?.id,
    );

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _handleBackAndAutoSaveDraft();
      },
      child: TeduhLoadingOverlay(
        isLoading: _isSending,
        message: 'Mengirim surat...',
        child: Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.48, 1.0],
                colors: [
                  AppColors.offWhite,
                  AppColors.offWhite,
                  Color(0xFF9AB08A),
                ],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 24, 4),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: AppColors.forestGreen,
                            size: 20,
                          ),
                          onPressed: _handleBackAndAutoSaveDraft,
                        ),
                        const Expanded(
                          child: Text(
                            'New Mail',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.forestGreen,
                            ),
                          ),
                        ),
                        const SizedBox(width: 28),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _subjectController,
                            textCapitalization: TextCapitalization.sentences,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.forestGreen,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Mail Subject',
                              hintStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.forestGreen,
                              ),
                              filled: false,
                              contentPadding: const EdgeInsets.only(bottom: 10),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.forestGreen.withValues(
                                    alpha: 0.35,
                                  ),
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.forestGreen.withValues(
                                    alpha: 0.35,
                                  ),
                                ),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.forestGreen,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  MailComposerBar(
                    controller: _bodyController,
                    hintText: 'Compose mail',
                    attachments: _attachments,
                    onAddAttachment: _addSimulatedAttachment,
                    onRemoveAttachment: (idx) =>
                        setState(() => _attachments.removeAt(idx)),
                    onSend: _sendMail,
                    isSending: _isSending,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
