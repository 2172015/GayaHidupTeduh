import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'screens/auth/loading_screen.dart';

void main() {
  runApp(const GayaHidupTeduhApp());
}

class GayaHidupTeduhApp extends StatelessWidget {
  const GayaHidupTeduhApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gaya Hidup Teduh',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoadingScreen(),
    );
  }
}
