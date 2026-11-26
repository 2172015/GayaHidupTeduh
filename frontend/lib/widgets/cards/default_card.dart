import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

abstract class DefaultCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final Color titleColor;
  final Color subtitleColor;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  const DefaultCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    this.titleColor = AppColors.forestGreen,
    this.subtitleColor = const Color(0xFF383329),
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    this.borderRadius = 22,
  });

  Widget? buildLeading(BuildContext context) => null;
  Widget? buildTrailing(BuildContext context) => null;

  @override
  Widget build(BuildContext context) {
    final leading = buildLeading(context);
    final trailing = buildTrailing(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          splashColor: AppColors.sageGreen.withValues(alpha: 0.2),
          highlightColor: AppColors.sageGreen.withValues(alpha: 0.1),
          child: Padding(
            padding: padding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (leading != null) ...[
                  leading,
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: titleColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12.5,
                          height: 1.35,
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 12),
                  trailing,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}