import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import 'login_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const LoginScreen(),
        ),
        // PageRouteBuilder(
        //   pageBuilder: (_, _, _) => const LoginScreen(),
        //   transitionsBuilder: (_, animation, _, child) {
        //     return FadeTransition(opacity: animation, child: child);
        //   },
        //   transitionDuration: const Duration(milliseconds: 400),
        // ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: Center(
        child: Image.asset(
          'assets/images/logos/Logo Hijau Tua.png',
          width: 500,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
