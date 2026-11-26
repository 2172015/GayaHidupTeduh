enum AppLanguage {
  system(
    label: 'Same as System',
    subtitle: 'Mengikuti pengaturan bahasa perangkat',
  ),
  indonesian(
    label: 'Bahasa Indonesia',
    subtitle: 'Tampilkan teks dalam Bahasa Indonesia',
  ),
  english(label: 'English', subtitle: 'Display interface text in English');

  final String label;
  final String subtitle;

  const AppLanguage({required this.label, required this.subtitle});
}

class AppSettings {
  final bool chatNotificationsEnabled;
  final bool reminderNotificationsEnabled;
  final bool promoEmailsEnabled;
  final bool showEmailToCounselor;
  final AppLanguage language;

  const AppSettings({
    this.chatNotificationsEnabled = true,
    this.reminderNotificationsEnabled = true,
    this.promoEmailsEnabled = false,
    this.showEmailToCounselor = true,
    this.language = AppLanguage.system,
  });

  AppSettings copyWith({
    bool? chatNotificationsEnabled,
    bool? reminderNotificationsEnabled,
    bool? promoEmailsEnabled,
    bool? showEmailToCounselor,
    AppLanguage? language,
  }) {
    return AppSettings(
      chatNotificationsEnabled:
          chatNotificationsEnabled ?? this.chatNotificationsEnabled,
      reminderNotificationsEnabled:
          reminderNotificationsEnabled ?? this.reminderNotificationsEnabled,
      promoEmailsEnabled: promoEmailsEnabled ?? this.promoEmailsEnabled,
      showEmailToCounselor: showEmailToCounselor ?? this.showEmailToCounselor,
      language: language ?? this.language,
    );
  }
}
