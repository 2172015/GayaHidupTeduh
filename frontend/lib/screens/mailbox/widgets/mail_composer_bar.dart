import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class MailComposerBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final List<String> attachments;
  final VoidCallback onAddAttachment;
  final ValueChanged<int> onRemoveAttachment;
  final VoidCallback onSend;
  final bool isSending;

  const MailComposerBar({
    super.key,
    required this.controller,
    required this.hintText,
    required this.attachments,
    required this.onAddAttachment,
    required this.onRemoveAttachment,
    required this.onSend,
    this.isSending = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 18, 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    tooltip: 'Lampirkan Gambar',
                    onPressed: attachments.length >= 5 ? null : onAddAttachment,
                    icon: const Icon(
                      Icons.attach_file_rounded,
                      color: Color(0xFF1E1E1E),
                      size: 24,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.pureWhite,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFF9E9E9E)),
                          ),
                          child: TextField(
                            controller: controller,
                            maxLines: 3,
                            minLines: 2,
                            textCapitalization: TextCapitalization.sentences,
                            style: const TextStyle(
                              fontSize: 13.5,
                              color: Color(0xFF1E1E1E),
                            ),
                            decoration: InputDecoration(
                              hintText: hintText,
                              hintStyle: const TextStyle(
                                fontSize: 13.5,
                                color: Color(0xFF8C9087),
                              ),
                              filled: false,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 6,
                              ),
                            ),
                          ),
                        ),
                        if (attachments.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: List.generate(attachments.length, (i) {
                              return Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      width: 68,
                                      height: 68,
                                      color: AppColors.offWhite,
                                      child: Image.asset(
                                        attachments[i],
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, _, _) => const Icon(
                                          Icons.image_rounded,
                                          color: AppColors.forestGreen,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: -6,
                                    right: -6,
                                    child: GestureDetector(
                                      onTap: () => onRemoveAttachment(i),
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.errorRed,
                                        ),
                                        child: const Icon(
                                          Icons.close_rounded,
                                          size: 13,
                                          color: AppColors.pureWhite,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ],
                        const SizedBox(height: 6),
                        Text(
                          'Max 5 images (5 MB) • ${attachments.length}/5 attached',
                          style: const TextStyle(
                            fontSize: 10.5,
                            color: Color(0xFF4F554B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  height: 42,
                  child: ElevatedButton(
                    onPressed: isSending ? null : onSend,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.forestGreen,
                      foregroundColor: AppColors.pureWhite,
                      minimumSize: const Size(118, 42),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Send',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.pureWhite,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.send_rounded,
                          size: 18,
                          color: AppColors.pureWhite,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
