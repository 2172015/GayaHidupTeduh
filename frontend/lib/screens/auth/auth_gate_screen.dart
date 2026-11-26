import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../widgets/common/loading_screen.dart';
import '../home/home_screen.dart';
import 'login_screen.dart';

class AuthGateScreen extends StatefulWidget {
  final AuthService? authService;

  const AuthGateScreen({super.key, this.authService});

  @override
  State<AuthGateScreen> createState() => _AuthGateScreenState();
}

class _AuthGateScreenState extends State<AuthGateScreen> {
  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = widget.authService ?? MockAuthService();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final currentUser = await _authService.getCurrentUser();
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (_) => currentUser != null
            ? HomeScreen(fullname: currentUser.username)
            : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const LoadingScreen(message: 'Menyiapkan ruang tenangmu...');
  }
}
