/// Kartu fitur utama di halaman beranda yang mewarisi [DefaultCard].
library;

import 'package:flutter/material.dart';

import '../../../widgets/cards/allow_image.dart';
import '../../../widgets/cards/default_card.dart';

/// Kartu navigasi fitur utama pada [HomeScreen] (seperti *Diary* dan *Book Counselor*).
///
/// Mewarisi seluruh properti tema, [isActive], [isEnabled], dan dukungan gambar
/// dari [DefaultCard].
class FeatureCard extends DefaultCard {
  FeatureCard({
    super.key,
    required String super.title,
    required String super.subtitle,
    super.backgroundColor,
    String? imageAssetPath,
    double imageWidth = 74,
    double imageHeight = 74,
    super.isActive,
    super.isEnabled,
    super.onTap,
  }) : super(
         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
         borderRadius: 22,
         cardImage: imageAssetPath != null
             ? CardImage(
                 assetPath: imageAssetPath,
                 width: imageWidth,
                 height: imageHeight,
                 position: CardImagePosition.right,
                 layer: CardImageLayer.inline,
               )
             : null,
       );
}
