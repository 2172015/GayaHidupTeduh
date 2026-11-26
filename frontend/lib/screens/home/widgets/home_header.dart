import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';

class HomeHeader extends StatelessWidget {
  final String username;
  final String avatarAsset;
  final VoidCallback? onAvatarTap;

  const HomeHeader({
    super.key,
    required this.username,
    this.avatarAsset = 'assets/images/profilepicture/pp1.png',
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, $username',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.forestGreen,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'Bagaimana perasaanmu hari ini?',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w400,
                color: Color(0xFF383329),
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: onAvatarTap,
          child: Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.pureWhite,
              border: Border.all(
                color: AppColors.forestGreen,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(avatarAsset, fit: BoxFit.cover),
            ),
          ),
        ),
      ],
    );
  }
}