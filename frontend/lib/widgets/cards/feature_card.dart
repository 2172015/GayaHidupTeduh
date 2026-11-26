import 'package:flutter/material.dart';

import 'default_card.dart';

class FeatureCard extends DefaultCard {
  final String? imageAssetPath;
  final double imageSize;

  const FeatureCard({
    super.key,
    required super.title,
    required super.subtitle,
    required super.backgroundColor,
    super.titleColor,
    super.subtitleColor,
    super.onTap,
    this.imageAssetPath,
    this.imageSize = 72,
  }) : super(
         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
         borderRadius: 24,
       );

  @override
  Widget? buildTrailing(BuildContext context) {
    if (imageAssetPath == null) return null;

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Image.asset(
        imageAssetPath!,
        width: imageSize,
        height: imageSize,
        fit: BoxFit.cover,
      ),
    );
  }
}
