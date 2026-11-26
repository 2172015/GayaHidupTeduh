import 'package:flutter/material.dart';

class TeduhLogo extends StatelessWidget {
  final double width;
  final double heightFactor;

  const TeduhLogo({super.key, this.width = 250, this.heightFactor = 0.55});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Align(
        alignment: Alignment.center,
        heightFactor: heightFactor,
        child: Image.asset(
          'assets/images/logos/Logo Hijau Tua.png',
          width: width,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
