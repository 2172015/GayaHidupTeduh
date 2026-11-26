import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import 'teduh_logo.dart';

class LoadingScreen extends StatelessWidget {
  final String message;
  final bool showLogo;

  const LoadingScreen({
    super.key,
    this.message = 'Menyiapkan ruang tenangmu...',
    this.showLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showLogo) ...[
                const TeduhLogo(width: 200),
                const SizedBox(height: 32),
              ],
              const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3.5,
                  color: AppColors.forestGreen,
                  backgroundColor: AppColors.sageGreen,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.forestGreen,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}