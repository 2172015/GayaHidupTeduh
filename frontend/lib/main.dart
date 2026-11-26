import 'package:flutter/material.dart';
import 'package:gaya_hidup_teduh/screens/auth/auth_gate_screen.dart';

import 'core/app_theme.dart';

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
      home: const AuthGateScreen(),
    );
  }
}
