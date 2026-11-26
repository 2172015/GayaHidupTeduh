import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/app_settings.dart';
import '../../services/profile_service.dart';

class SettingsScreen extends StatefulWidget {
  final String userId;
  final ProfileService profileService;

  const SettingsScreen({
    super.key,
    required this.userId,
    required this.profileService,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  AppSettings _settings = const AppSettings();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final loaded = await widget.profileService.getSettings(widget.userId);
    if (!mounted) return;
    setState(() {
      _settings = loaded;
      _isLoading = false;
    });
  }

  Future<void> _saveSettings(AppSettings updated) async {
    setState(() => _settings = updated);
    await widget.profileService.updateSettings(
      userId: widget.userId,
      settings: updated,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.48, 1.0],
            colors: [AppColors.offWhite, AppColors.offWhite, Color(0xFF9AB08A)],
          ),
        ),
        child: SafeArea(
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
                        'Pengaturan',
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
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.forestGreen,
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 14, 24, 28),
                        child: Column(
                          children: [
                            // Kartu 1: Notifikasi
                            _buildSectionCard(
                              title: 'Notifikasi',
                              children: [
                                _buildSwitchTile(
                                  title: 'Notifikasi Chat Konselor',
                                  subtitle: 'Terima pemberitahuan saat konselor membalas pesan di Mailbox',
                                  value: _settings.chatNotificationsEnabled,
                                  onChanged: (val) => _saveSettings(
                                    _settings.copyWith(
                                      chatNotificationsEnabled: val,
                                    ),
                                  ),
                                ),
                                Divider(
                                  height: 16,
                                  color: AppColors.forestGreen.withValues(
                                    alpha: 0.14,
                                  ),
                                ),
                                _buildSwitchTile(
                                  title: 'Notifikasi Reminder Harian',
                                  subtitle: 'Pengingat untuk mengisi Mood Tracker dan jadwal sesi konseling',
                                  value: _settings.reminderNotificationsEnabled,
                                  onChanged: (val) => _saveSettings(
                                    _settings.copyWith(
                                      reminderNotificationsEnabled: val,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Kartu 2: Email & Privasi
                            _buildSectionCard(
                              title: 'Email & Privasi',
                              children: [
                                _buildSwitchTile(
                                  title: 'Email Update & Promo',
                                  subtitle: 'Terima informasi fitur baru dan voucher promo melalui email',
                                  value: _settings.promoEmailsEnabled,
                                  onChanged: (val) => _saveSettings(
                                    _settings.copyWith(promoEmailsEnabled: val),
                                  ),
                                ),
                                Divider(
                                  height: 16,
                                  color: AppColors.forestGreen.withValues(
                                    alpha: 0.14,
                                  ),
                                ),
                                _buildSwitchTile(
                                  title: 'Tampilkan Email ke Konselor',
                                  subtitle: 'Izinkan konselor melihat alamat emailmu pada detail sesi',
                                  value: _settings.showEmailToCounselor,
                                  onChanged: (val) => _saveSettings(
                                    _settings.copyWith(
                                      showEmailToCounselor: val,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Kartu 3: Preferensi Aplikasi (Bahasa)
                            _buildSectionCard(
                              title: 'Preferensi Aplikasi',
                              children: AppLanguage.values.map((lang) {
                                final isSelected = _settings.language == lang;
                                return InkWell(
                                  onTap: () => _saveSettings(
                                    _settings.copyWith(language: lang),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                lang.label,
                                                style: const TextStyle(
                                                  fontSize: 14.5,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF1E1E1E),
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                lang.subtitle,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF7A7E75),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          isSelected
                                              ? Icons
                                                    .radio_button_checked_rounded
                                              : Icons.radio_button_off_rounded,
                                          color: isSelected
                                              ? AppColors.forestGreen
                                              : const Color(0xFFBDBDBD),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.forestGreen.withValues(alpha: 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.forestGreen,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E1E1E),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.35,
                  color: Color(0xFF7A7E75),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Switch(
          value: value,
          activeTrackColor: AppColors.forestGreen,
          activeThumbColor: AppColors.pureWhite,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
