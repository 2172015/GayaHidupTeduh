import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/user_profile.dart';

class ProfileHeaderCard extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback onEditPressed;

  const ProfileHeaderCard({
    super.key,
    required this.profile,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    final hasBio = profile.description.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.forestGreen.withValues(alpha: 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 78,
                height: 78,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.sageGreen.withValues(alpha: 0.35),
                  border: Border.all(
                    color: AppColors.forestGreen.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    profile.avatarAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.person_rounded,
                      size: 42,
                      color: AppColors.forestGreen,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Identitas Utama
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.fullName,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: AppColors.forestGreen,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      '@${profile.username}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF7A7E75),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(
                          Icons.mail_outline_rounded,
                          size: 13.5,
                          color: Color(0xFF5A5E56),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            profile.email,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: Color(0xFF5A5E56),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      hasBio ? profile.description : 'Tambahkan deskripsi singkat tentang perjalananmu...',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        fontStyle: hasBio ? FontStyle.normal : FontStyle.italic,
                        color: hasBio
                            ? const Color(0xFF383329)
                            : const Color(0xFF8C9087),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Tombol Edit Profile
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: onEditPressed,
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.pureWhite,
                foregroundColor: AppColors.forestGreen,
                side: const BorderSide(
                  color: AppColors.forestGreen,
                  width: 1.4,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.forestGreen,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
