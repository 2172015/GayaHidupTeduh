import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/utils/form_validator.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../widgets/common/teduh_loading_overlay.dart';
import '../../widgets/common/teduh_logo.dart';
import '../../widgets/inputs/password_strength_checklist.dart';
import '../../widgets/inputs/teduh_phone_field.dart';
import '../../widgets/inputs/teduh_text_field.dart';
import '../home/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  final AuthService? authService;

  const RegisterScreen({super.key, this.authService});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  late final AuthService _authService;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _selectedCountryCode = '+62';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authService = widget.authService ?? MockAuthService();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final draftUser = UserModel(
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      phoneNumber: TeduhPhoneField.formatPhoneNumber(
        _selectedCountryCode,
        _phoneController.text,
      ),
      password: _passwordController.text,
      createdAt: DateTime.now(),
    );

    final registeredUser = await _authService.register(draftUser);
    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute<void>(
        builder: (context) => HomeScreen(fullname: registeredUser.fullName),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TeduhLoadingOverlay(
      isLoading: _isLoading,
      message: 'Menyiapkan akunmu...',
      child: Scaffold(
        backgroundColor: AppColors.offWhite,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 28.0,
                vertical: 24.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const TeduhLogo(width: 250),
                    const SizedBox(height: 24),

                    Text(
                      'Buat Akun Baru',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Mulai perjalanan tenangmu bersama Teduh',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TeduhTextField(
                            controller: _firstNameController,
                            hintText: 'First Name',
                            textCapitalization: TextCapitalization.words,
                            validator: (v) => FormValidator.validateName(
                              v,
                              fieldName: 'First Name',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TeduhTextField(
                            controller: _lastNameController,
                            hintText: 'Last Name',
                            textCapitalization: TextCapitalization.words,
                            validator: (v) => FormValidator.validateName(
                              v,
                              fieldName: 'Last Name',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    TeduhTextField(
                      controller: _usernameController,
                      hintText: 'Username',
                      validator: FormValidator.validateUsername,
                    ),
                    const SizedBox(height: 14),

                    TeduhTextField(
                      controller: _emailController,
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: FormValidator.validateEmail,
                    ),
                    const SizedBox(height: 14),

                    TeduhPhoneField(
                      controller: _phoneController,
                      onCountryCodeChanged: (code) =>
                          _selectedCountryCode = code,
                    ),
                    const SizedBox(height: 14),

                    TeduhTextField(
                      controller: _passwordController,
                      hintText: 'Password',
                      isPassword: true,
                      validator: FormValidator.validatePassword,
                    ),
                    PasswordStrengthChecklist(
                      passwordController: _passwordController,
                    ),
                    const SizedBox(height: 14),

                    TeduhTextField(
                      controller: _confirmPasswordController,
                      hintText: 'Confirm Password',
                      isPassword: true,
                      onFieldSubmitted: (_) => _submitRegister(),
                      validator: (v) => FormValidator.validateConfirmPassword(
                        v,
                        _passwordController.text,
                      ),
                    ),
                    const SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: _isLoading ? null : _submitRegister,
                      child: const Text('Daftar'),
                    ),
                    const SizedBox(height: 14),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sudah punya akun? ',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            'Masuk di sini',
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
