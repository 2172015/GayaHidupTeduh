import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/user_profile.dart';
import '../../services/profile_service.dart';
import '../../widgets/common/teduh_bottom_action_bar.dart';
import '../../widgets/common/teduh_loading_overlay.dart';

class ChangeUsernameScreen extends StatefulWidget {
  final UserProfile profile;
  final ProfileService profileService;

  const ChangeUsernameScreen({
    super.key,
    required this.profile,
    required this.profileService,
  });

  @override
  State<ChangeUsernameScreen> createState() => _ChangeUsernameScreenState();
}

class _ChangeUsernameScreenState extends State<ChangeUsernameScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _usernameController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.profile.username);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  String? _validateUsername(String? value) {
    final trimmed = (value ?? '').trim();
    if (trimmed.isEmpty) {
      return 'Username tidak boleh kosong.';
    }
    if (trimmed.length < 4) {
      return 'Username minimal 4 karakter.';
    }
    if (trimmed.contains(' ')) {
      return 'Username tidak boleh mengandung spasi.';
    }
    final validPattern = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!validPattern.hasMatch(trimmed)) {
      return 'Username hanya boleh berisi huruf, angka, dan underscore (_).';
    }
    if (trimmed == widget.profile.username) {
      return 'Masukkan username baru yang berbeda dari sebelumnya.';
    }
    return null;
  }

  Future<void> _saveUsername() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final updated = await widget.profileService.updateUsername(
        userId: widget.profile.id,
        newUsername: _usernameController.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username berhasil diperbarui.'),
          backgroundColor: AppColors.forestGreen,
        ),
      );
      Navigator.pop(context, updated);
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
      message: 'Memperbarui username...',
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
                          'Ubah Username',
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
                            'Username digunakan sebagai identitas unikmu di Gaya Hidup Teduh. Gunakan minimal 4 karakter tanpa spasi.',
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
                                const Text(
                                  'Username Baru',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.forestGreen,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _usernameController,
                                  validator: _validateUsername,
                                  style: const TextStyle(
                                    fontSize: 14.5,
                                    color: Color(0xFF1E1E1E),
                                  ),
                                  decoration: InputDecoration(
                                    prefixText: '@ ',
                                    prefixStyle: const TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.forestGreen,
                                    ),
                                    hintText: 'username_baru',
                                    filled: true,
                                    fillColor: AppColors.pureWhite,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 13,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(24),
                                      borderSide: BorderSide(
                                        color: AppColors.forestGreen.withValues(
                                          alpha: 0.5,
                                        ),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(24),
                                      borderSide: BorderSide(
                                        color: AppColors.forestGreen.withValues(
                                          alpha: 0.5,
                                        ),
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
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                TeduhBottomActionBar.primary(
                  label: 'Simpan Username',
                  isDisabled: _isSaving,
                  onPressed: _saveUsername,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
