import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/user_gender.dart';
import '../../models/user_profile.dart';
import '../../services/profile_service.dart';
import '../../widgets/common/teduh_bottom_action_bar.dart';
import '../../widgets/common/teduh_loading_overlay.dart';
import 'widgets/avatar_preset_selector.dart';

class EditProfileScreen extends StatefulWidget {
  final UserProfile profile;
  final ProfileService profileService;

  const EditProfileScreen({
    super.key,
    required this.profile,
    required this.profileService,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _bioController;

  late UserGender _selectedGender;
  late String _selectedAvatar;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(
      text: widget.profile.firstName,
    );
    _lastNameController = TextEditingController(text: widget.profile.lastName);
    _phoneController = TextEditingController(text: widget.profile.phoneNumber);
    _bioController = TextEditingController(text: widget.profile.description);
    _selectedGender = widget.profile.gender;
    _selectedAvatar = widget.profile.avatarAsset;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _onGenderChanged(UserGender? newGender) {
    if (newGender == null) return;
    setState(() {
      _selectedGender = newGender;
      if (newGender == UserGender.male &&
          !AvatarPresetSelector.malePresets.contains(_selectedAvatar)) {
        _selectedAvatar = AvatarPresetSelector.malePresets.first;
      } else if (newGender == UserGender.female &&
          !AvatarPresetSelector.femalePresets.contains(_selectedAvatar)) {
        _selectedAvatar = AvatarPresetSelector.femalePresets.first;
      }
    });
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final updated = await widget.profileService.updateProfile(
      widget.profile.copyWith(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        gender: _selectedGender,
        description: _bioController.text.trim(),
        avatarAsset: _selectedAvatar,
      ),
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Perubahan profil berhasil disimpan.'),
        backgroundColor: AppColors.forestGreen,
      ),
    );
    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    return TeduhLoadingOverlay(
      isLoading: _isSaving,
      message: 'Menyimpan profil...',
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
                // Header
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
                          'Edit Profile',
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

                // Form Scrollable
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          AvatarPresetSelector(
                            selectedGender: _selectedGender,
                            selectedAvatarAsset: _selectedAvatar,
                            onAvatarSelected: (asset) =>
                                setState(() => _selectedAvatar = asset),
                          ),
                          const SizedBox(height: 20),

                          // Container Form Utama
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: AppColors.offWhite,
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: AppColors.forestGreen.withValues(
                                  alpha: 0.35,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('Nama Depan'),
                                _buildRoundedTextField(
                                  controller: _firstNameController,
                                  hint: 'Masukkan nama depan',
                                  validator: (val) =>
                                      (val == null || val.trim().isEmpty)
                                      ? 'Nama depan wajib diisi'
                                      : null,
                                ),
                                const SizedBox(height: 14),

                                _buildLabel('Nama Belakang'),
                                _buildRoundedTextField(
                                  controller: _lastNameController,
                                  hint: 'Masukkan nama belakang',
                                  validator: (val) =>
                                      (val == null || val.trim().isEmpty)
                                      ? 'Nama belakang wajib diisi'
                                      : null,
                                ),
                                const SizedBox(height: 14),

                                _buildLabel('Nomor Telepon'),
                                _buildRoundedTextField(
                                  controller: _phoneController,
                                  hint: '+62 812-3456-7890',
                                  keyboardType: TextInputType.phone,
                                  validator: (val) =>
                                      (val == null || val.trim().length < 8)
                                      ? 'Nomor telepon tidak valid'
                                      : null,
                                ),
                                const SizedBox(height: 14),

                                _buildLabel('Jenis Kelamin'),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.offWhite,
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: AppColors.forestGreen.withValues(
                                        alpha: 0.55,
                                      ),
                                    ),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<UserGender>(
                                      value: _selectedGender,
                                      isExpanded: true,
                                      dropdownColor: AppColors.offWhite,
                                      icon: const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: AppColors.forestGreen,
                                      ),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF1E1E1E),
                                      ),
                                      items: UserGender.values.map((g) {
                                        return DropdownMenuItem(
                                          value: g,
                                          child: Text(g.label),
                                        );
                                      }).toList(),
                                      onChanged: _onGenderChanged,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),

                                _buildLabel('Bio Singkat'),
                                _buildRoundedTextField(
                                  controller: _bioController,
                                  hint: 'Ceritakan sedikit tentang dirimu...',
                                  maxLines: 3,
                                  borderRadius: 18,
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
                  label: 'Save Changes',
                  isDisabled: _isSaving,
                  onPressed: _saveChanges,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w700,
          color: AppColors.forestGreen,
        ),
      ),
    );
  }

  Widget _buildRoundedTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    double borderRadius = 24,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(fontSize: 14, color: Color(0xFF1E1E1E)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13.5, color: Color(0xFF9E9E9E)),
        filled: true,
        fillColor: AppColors.offWhite,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: AppColors.forestGreen.withValues(alpha: 0.55),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: AppColors.forestGreen.withValues(alpha: 0.55),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(
            color: AppColors.forestGreen,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
