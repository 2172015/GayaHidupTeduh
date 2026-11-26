import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class ProfileMenuItemData {
  final String title;
  final VoidCallback onTap;

  const ProfileMenuItemData({required this.title, required this.onTap});
}

class ProfileMenuCard extends StatelessWidget {
  final List<ProfileMenuItemData> items;

  const ProfileMenuCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: List.generate(items.length, (index) {
            final item = items[index];
            final isLast = index == items.length - 1;
            return Column(
              children: [
                InkWell(
                  onTap: item.onTap,
                  splashColor: AppColors.sageGreen.withValues(alpha: 0.2),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                            color: AppColors.forestGreen,
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: 20,
                          color: AppColors.forestGreen,
                        ),
                      ],
                    ),
                  ),
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    indent: 20,
                    endIndent: 20,
                    color: AppColors.forestGreen.withValues(alpha: 0.16),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
