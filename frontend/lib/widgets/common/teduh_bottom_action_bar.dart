import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class TeduhBottomActionBar extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isOutlined;
  final bool isDisabled;

  const TeduhBottomActionBar.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.isDisabled = false,
  }) : isOutlined = false;

  const TeduhBottomActionBar.outlined({
    super.key,
    required this.label,
    required this.onPressed,
    this.isDisabled = false,
  }) : isOutlined = true;

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = isDisabled ? null : onPressed;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 14),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: isOutlined
                ? OutlinedButton(
                    onPressed: effectiveOnPressed,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.pureWhite,
                      foregroundColor: AppColors.forestGreen,
                      side: const BorderSide(
                        color: AppColors.forestGreen,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.forestGreen,
                      ),
                    ),
                  )
                : ElevatedButton(
                    onPressed: effectiveOnPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.sageGreen,
                      foregroundColor: AppColors.forestGreen,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.forestGreen,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}