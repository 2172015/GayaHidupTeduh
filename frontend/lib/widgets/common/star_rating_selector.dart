import 'package:flutter/material.dart';

class StarRatingSelector extends StatelessWidget {
  final int rating;
  final ValueChanged<int>? onRatingChanged;
  final double size;

  const StarRatingSelector({
    super.key,
    required this.rating,
    this.onRatingChanged,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        final isFilled = starIndex <= rating;
        return GestureDetector(
          onTap: onRatingChanged != null
              ? () => onRatingChanged!(starIndex)
              : null,
          child: Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Icon(
              isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
              size: size,
              color: isFilled
                  ? const Color(0xFFE5A93B)
                  : const Color(0xFF4F554B),
            ),
          ),
        );
      }),
    );
  }
}
