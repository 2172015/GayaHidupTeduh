import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/navigation/app_navigator.dart';
import '../../models/counseling_booking.dart';
import '../../models/mail_thread.dart';
import '../../services/mailbox_service.dart';
import '../../widgets/navigation/bottom_navigation_bar.dart';
import 'mail_thread_screen.dart';
import 'new_mail_screen.dart';
import 'widgets/counselor_session_header.dart';
import 'widgets/mail_thread_card.dart';

class SessionMailboxScreen extends StatefulWidget {
  final CounselingBooking booking;
  final MailboxService? mailboxService;

  const SessionMailboxScreen({
    super.key,
    required this.booking,
    this.mailboxService,
  });

  @override
  State<SessionMailboxScreen> createState() => _SessionMailboxScreenState();
}

class _SessionMailboxScreenState extends State<SessionMailboxScreen> {
  late final MailboxService _mailboxService;
  List<MailThread> _threads = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _mailboxService = widget.mailboxService ?? MockMailboxService();
    _loadThreads();
  }

  Future<void> _loadThreads() async {
    setState(() => _isLoading = true);
    final items = await _mailboxService.getThreadsForSession(widget.booking);
    if (!mounted) return;
    setState(() {
      _threads = items;
      _isLoading = false;
    });
  }

  Future<void> _openNewMail({MailThread? existingDraft}) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (_) => NewMailScreen(
          booking: widget.booking,
          mailboxService: _mailboxService,
          existingDraft: existingDraft,
        ),
      ),
    );
    if (changed == true) _loadThreads();
  }

  Future<void> _openThread(MailThread thread) async {
    if (thread.isDraft) {
      await _openNewMail(existingDraft: thread);
      return;
    }

    await _mailboxService.markThreadAsRead(thread.id);
    if (!mounted) return;

    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => MailThreadScreen(
          thread: thread.copyWith(isUnread: false),
          mailboxService: _mailboxService,
        ),
      ),
    );
    _loadThreads();
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
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'Mailbox',
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
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 14),
                child: CounselorSessionHeader(booking: widget.booking),
              ),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.forestGreen,
                        ),
                      )
                    : _threads.isEmpty
                    ? const Center(
                        child: Text(
                          'Belum ada pesan untuk sesi ini.',
                          style: TextStyle(
                            fontSize: 13.5,
                            color: Color(0xFF383329),
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 88),
                        itemCount: _threads.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final thread = _threads[index];
                          return MailThreadCard(
                            thread: thread,
                            onTap: () => _openThread(thread),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openNewMail(),
        backgroundColor: AppColors.forestGreen,
        foregroundColor: AppColors.pureWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
        icon: const Icon(
          Icons.mark_email_unread_outlined,
          color: AppColors.sageGreen,
          size: 22,
        ),
        label: const Text(
          'New Mail',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      bottomNavigationBar: TeduhBottomNav(
        currentIndex: 2,
        onTap: (index) => AppNavigator.onBottomNavTapped(
          context,
          currentIndex: 2,
          targetIndex: index,
        ),
      ),
    );
  }
}
