import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../services/profile_service.dart';
import '../../widgets/common/teduh_bottom_action_bar.dart';
import '../../widgets/common/teduh_loading_overlay.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String userId;
  final ProfileService profileService;

  const ChangePasswordScreen({
    super.key,
    required this.userId,
    required this.profileService,
  });

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isSaving = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitPasswordChange() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      await widget.profileService.changePassword(
        userId: widget.userId,
        oldPassword: _oldPasswordController.text,
        newPassword: _newPasswordController.text,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kata sandi berhasil diperbarui.'),
          backgroundColor: AppColors.forestGreen,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: AppColors.errorRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TeduhLoadingOverlay(
      isLoading: _isSaving,
      message: 'Memperbarui kata sandi...',
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.48, 1.0],
              colors: [
                AppColors.offWhite,
                AppColors.offWhite,
                Color(0xFF9AB08A),
              ],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 24, 4),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppColors.forestGreen,
                          size: 20,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text(
                          'Ubah Kata Sandi',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.forestGreen,
                          ),
                        ),
                      ),
                      const SizedBox(width: 28),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Masukkan kata sandi lamamu terlebih dahulu, lalu buat kata sandi baru minimal 8 karakter.',
                            style: TextStyle(
                              fontSize: 13.5,
                              height: 1.45,
                              color: Color(0xFF383329),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: AppColors.offWhite,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.forestGreen.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildPasswordField(
                                  label: 'Kata Sandi Lama',
                                  hint: 'Masukkan kata sandi saat ini',
                                  controller: _oldPasswordController,
                                  obscureText: _obscureOld,
                                  onToggleObscure: () => setState(
                                    () => _obscureOld = !_obscureOld,
                                  ),
                                  validator: (val) =>
                                      (val == null || val.isEmpty)
                                      ? 'Kata sandi lama wajib diisi'
                                      : null,
                                ),
                                const SizedBox(height: 14),
                                _buildPasswordField(
                                  label: 'Kata Sandi Baru',
                                  hint: 'Minimal 8 karakter',
                                  controller: _newPasswordController,
                                  obscureText: _obscureNew,
                                  onToggleObscure: () => setState(
                                    () => _obscureNew = !_obscureNew,
                                  ),
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return 'Kata sandi baru wajib diisi';
                                    }
                                    if (val.length < 8) {
                                      return 'Kata sandi minimal 8 karakter';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 14),
                                _buildPasswordField(
                                  label: 'Konfirmasi Kata Sandi Baru',
                                  hint: 'Ulangi kata sandi baru',
                                  controller: _confirmPasswordController,
                                  obscureText: _obscureConfirm,
                                  onToggleObscure: () => setState(
                                    () => _obscureConfirm = !_obscureConfirm,
                                  ),
                                  validator: (val) {
                                    if (val != _newPasswordController.text) {
                                      return 'Konfirmasi kata sandi tidak cocok';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              'Catatan uji coba mock: kata sandi default awal adalah "password123".',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: Color(0xFF5A5E56),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                TeduhBottomActionBar.primary(
                  label: 'Simpan Kata Sandi',
                  isDisabled: _isSaving,
                  onPressed: _submitPasswordChange,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggleObscure,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: AppColors.forestGreen,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          style: const TextStyle(fontSize: 14, color: Color(0xFF1E1E1E)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 13.5,
              color: Color(0xFF9E9E9E),
            ),
            filled: true,
            fillColor: AppColors.pureWhite,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.forestGreen,
                size: 20,
              ),
              onPressed: onToggleObscure,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(
                color: AppColors.forestGreen.withValues(alpha: 0.5),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(
                color: AppColors.forestGreen.withValues(alpha: 0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: const BorderSide(
                color: AppColors.forestGreen,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
