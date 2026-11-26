import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import 'default_card.dart';

class NotificationCard extends DefaultCard {
  final IconData? leadingIcon;
  final Color? leadingIconColor;
  final bool showUnreadDot;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  const NotificationCard({
    super.key,
    required super.title,
    required super.subtitle,
    required super.backgroundColor,
    super.titleColor,
    super.subtitleColor,
    super.onTap,
    this.leadingIcon,
    this.leadingIconColor,
    this.showUnreadDot = false,
    this.actionLabel,
    this.onActionPressed,
  }) : super(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          borderRadius: 20,
        );

  /// Preset constructor for unread counselor mail notifications
  const NotificationCard.mail({
    super.key,
    super.title = 'Mailbox Baru!',
    required super.subtitle,
    this.showUnreadDot = true,
    super.onTap,
  })  : leadingIcon = Icons.mail_outline_rounded,
        leadingIconColor = AppColors.forestGreen,
        actionLabel = null,
        onActionPressed = null,
        super(
          backgroundColor: AppColors.pureWhite,
          titleColor: AppColors.forestGreen,
          subtitleColor: const Color(0xFF383329),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          borderRadius: 20,
        );

  /// Preset constructor for counseling schedule reminders
  NotificationCard.reminder({
    super.key,
    super.title = 'Jadwal Konseling',
    required super.subtitle,
    this.actionLabel = 'Lihat Detail',
    this.onActionPressed,
    super.onTap,
  })  : leadingIcon = null,
        leadingIconColor = null,
        showUnreadDot = false,
        super(
          backgroundColor: AppColors.forestGreen,
          titleColor: AppColors.pureWhite,
          subtitleColor: AppColors.pureWhite.withValues(alpha: 0.9),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          borderRadius: 20,
        );

  @override
  Widget? buildLeading(BuildContext context) {
    if (leadingIcon == null) return null;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(
          leadingIcon,
          size: 40,
          color: leadingIconColor ?? titleColor,
        ),
        if (showUnreadDot)
          Positioned(
            top: 2,
            right: -2,
            child: Container(
              width: 11,
              height: 11,
              decoration: const BoxDecoration(
                color: Color(0xFFE53935),
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget? buildTrailing(BuildContext context) {
    if (actionLabel == null) return null;

    return Material(
      color: const Color(0xFFE9D8A6),
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onActionPressed ?? onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          child: Text(
            actionLabel!,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF383329),
            ),
          ),
        ),
      ),
    );
  }
}