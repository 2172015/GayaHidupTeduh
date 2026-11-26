import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../widgets/common/teduh_loading_overlay.dart';
import '../../widgets/inputs/teduh_text_field.dart';
import '../home/home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulasi request API (ganti dengan HTTP call Laravel nanti)
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    if (username == 'User' && password == '123456') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (context) => HomeScreen(fullname: username),
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Username atau password salah. (Demo: User / 123456)';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TeduhLoadingOverlay(
      isLoading: _isLoading,
      message: 'Masuk ke akunmu...',
      child: Scaffold(
        backgroundColor: AppColors.offWhite,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRect(
                      child: Align(
                        alignment: Alignment.center,
                        heightFactor: 0.55,
                        child: Image.asset(
                          'assets/images/logos/Logo Hijau Tua.png',
                          width: 300,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),

                    Text(
                      'Selamat Datang Kembali',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    TeduhTextField(
                      controller: _usernameController,
                      hintText: 'Username',
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Username wajib diisi.'
                          : null,
                    ),
                    const SizedBox(height: 14),

                    TeduhTextField(
                      controller: _passwordController,
                      hintText: 'Password',
                      isPassword: true,
                      onFieldSubmitted: (_) => _login(),
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Password wajib diisi.'
                          : null,
                    ),

                    if (_errorMessage != null) ...[
                      const SizedBox(height: 14),
                      Text(
                        _errorMessage!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.errorRed,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],

                    const SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      child: const Text('Masuk'),
                    ),
                    const SizedBox(height: 14),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Belum punya akun? ',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Daftar di sini',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppColors.lightForestGreen,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
