import '../models/app_settings.dart';
import '../models/user_gender.dart';
import '../models/user_profile.dart';

abstract class ProfileService {
  Future<UserProfile> getProfile(String userId);
  Future<UserProfile> updateProfile(UserProfile updated);
  Future<UserProfile> updateUsername({
    required String userId,
    required String newUsername,
  });
  Future<void> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  });
  Future<AppSettings> getSettings(String userId);
  Future<AppSettings> updateSettings({
    required String userId,
    required AppSettings settings,
  });
}

class MockProfileService implements ProfileService {
  static UserProfile _currentProfile = const UserProfile(
    id: '278392',
    username: 'daveandrew',
    email: 'dave.andrew@teduh.id',
    firstName: 'Dave',
    lastName: 'Andrew',
    phoneNumber: '+62 812-3456-7890',
    gender: UserGender.preferNotToSay,
    description: 'Merawat ketenangan satu hari pada satu waktu.',
    avatarAsset: 'assets/images/profilepicture/male_1.jpg',
  );

  static String _currentPassword = 'password123';
  static AppSettings _settings = const AppSettings();

  @override
  Future<UserProfile> getProfile(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _currentProfile;
  }

  @override
  Future<UserProfile> updateProfile(UserProfile updated) async {
    await Future.delayed(const Duration(milliseconds: 350));
    _currentProfile = updated;
    return _currentProfile;
  }

  @override
  Future<UserProfile> updateUsername({
    required String userId,
    required String newUsername,
  }) async {
    await Future.delayed(const Duration(milliseconds: 350));
    final clean = newUsername.trim().replaceFirst('@', '');
    if (clean.toLowerCase() == 'admin' || clean.toLowerCase() == 'teduh') {
      throw Exception('Username sudah digunakan oleh pengguna lain.');
    }
    _currentProfile = _currentProfile.copyWith(username: clean);
    return _currentProfile;
  }

  @override
  Future<void> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (oldPassword != _currentPassword) {
      throw Exception('Kata sandi lama tidak sesuai.');
    }
    if (oldPassword == newPassword) {
      throw Exception('Kata sandi baru tidak boleh sama dengan yang lama.');
    }
    _currentPassword = newPassword;
  }

  @override
  Future<AppSettings> getSettings(String userId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _settings;
  }

  @override
  Future<AppSettings> updateSettings({
    required String userId,
    required AppSettings settings,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _settings = settings;
    return _settings;
  }
}
