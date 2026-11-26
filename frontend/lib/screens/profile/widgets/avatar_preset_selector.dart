import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/user_gender.dart';

class AvatarPresetSelector extends StatelessWidget {
  final UserGender selectedGender;
  final String selectedAvatarAsset;
  final ValueChanged<String> onAvatarSelected;

  const AvatarPresetSelector({
    super.key,
    required this.selectedGender,
    required this.selectedAvatarAsset,
    required this.onAvatarSelected,
  });

  static const List<String> malePresets = [
    'assets/images/profilepicture/male_1.jpg',
    'assets/images/profilepicture/male_2.jpg',
  ];

  static const List<String> femalePresets = [
    'assets/images/profilepicture/female_1.jpg',
    'assets/images/profilepicture/female_2.jpg',
  ];

  List<String> get _availablePresets {
    switch (selectedGender) {
      case UserGender.male:
        return malePresets;
      case UserGender.female:
        return femalePresets;
      case UserGender.preferNotToSay:
        return [...malePresets, ...femalePresets];
    }
  }

  @override
  Widget build(BuildContext context) {
    final presets = _availablePresets;

    return Column(
      children: [
        // Avatar Aktif Besar
        Container(
          width: 112,
          height: 112,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.sageGreen.withValues(alpha: 0.35),
            border: Border.all(color: AppColors.forestGreen, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              selectedAvatarAsset,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.person_rounded,
                size: 56,
                color: AppColors.forestGreen,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Pilih avatar preset',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF7A7E75),
          ),
        ),
        const SizedBox(height: 10),

        // Deretan Avatar Preset
        Wrap(
          spacing: 12,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: presets.map((assetPath) {
            final isSelected = selectedAvatarAsset == assetPath;
            return GestureDetector(
              onTap: () => onAvatarSelected(assetPath),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 56,
                height: 56,
                padding: const EdgeInsets.all(2.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.forestGreen
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: Container(
                    color: AppColors.sageGreen.withValues(alpha: 0.25),
                    child: Image.asset(
                      assetPath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.face_rounded,
                        size: 28,
                        color: AppColors.forestGreen,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
