import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';

class TreeOfLifeWidget extends StatelessWidget {
  final int streakDays;
  final VoidCallback onTap;

  const TreeOfLifeWidget({
    super.key,
    required this.streakDays,
    required this.onTap,
  });

  String get _treeAssetPath {
    if (streakDays < 7) return 'assets/images/homepage/Streak1-png.png';
    if (streakDays < 14) return 'assets/images/homepage/Streak2-png.png';
    if (streakDays < 21) return 'assets/images/homepage/Streak3-png.png';
    return 'assets/images/homepage/Streak4-png.png';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Pohon Kehidupan',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.forestGreen,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 240,
          height: 240,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Material(
            color: AppColors.forestGreen,
            shape: const CircleBorder(
              side: BorderSide(color: Color(0xFFB2C0A6), width: 5),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              customBorder: const CircleBorder(),
              splashColor: AppColors.sageGreen.withValues(alpha: 0.25),
              highlightColor: AppColors.sageGreen.withValues(alpha: 0.12),
              onTap: onTap,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    bottom: 35,
                    child: Image.asset(
                      _treeAssetPath,
                      width: 230,
                      height: 230,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.water_drop_rounded,
                              color: Color(0xFF90D5FF),
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$streakDays Hari',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: AppColors.pureWhite,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Ketuk untuk Check-In',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.pureWhite,
                                fontSize: 11,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}