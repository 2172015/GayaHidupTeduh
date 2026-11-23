import 'package:flutter/material.dart';

import '../core/app_colors.dart';

class FeatureCard extends StatelessWidget {
  final Color backgroundColor;
  final Color borderColor;
  final String title;
  final String subtitle;
  final String? trailingImage;
  final VoidCallback onTap;

  const FeatureCard({
    super.key,
    required this.backgroundColor,
    required this.borderColor,
    required this.title,
    required this.subtitle,
    this.trailingImage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.forestGreen,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w400,
                          color: AppColors.forestGreen,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailingImage != null) ...[
                  const SizedBox(width: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      trailingImage!,
                      width: 78,
                      height: 86,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
