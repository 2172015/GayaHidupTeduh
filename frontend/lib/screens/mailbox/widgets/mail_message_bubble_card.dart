import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../models/mail_message.dart';

class MailMessageBubbleCard extends StatelessWidget {
  final MailMessage message;

  const MailMessageBubbleCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.sageGreen.withValues(alpha: 0.35),
                ),
                child: ClipOval(
                  child: Image.asset(
                    message.senderAvatarAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const Icon(
                      Icons.person_rounded,
                      size: 22,
                      color: AppColors.forestGreen,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message.senderName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                message.formattedTimestamp,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: Color(0xFF5A5E56),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            message.body,
            style: const TextStyle(
              fontSize: 13.5,
              height: 1.45,
              color: Color(0xFF1E1E1E),
            ),
          ),
          if (message.attachmentAssets.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: message.attachmentAssets.map((asset) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 60,
                    height: 60,
                    color: AppColors.offWhite,
                    child: Image.asset(
                      asset,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.image_outlined,
                        color: AppColors.forestGreen,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
