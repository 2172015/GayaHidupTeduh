import '../models/user_model.dart';

abstract class AuthService {
  Future<UserModel?> getCurrentUser();
  Future<UserModel> register(UserModel user);
  Future<UserModel> login(String username, String password);
}

class MockAuthService implements AuthService {
  @override
  Future<UserModel?> getCurrentUser() async {
    // Simulasi pengecekan token tersimpan saat aplikasi dibuka
    await Future.delayed(const Duration(milliseconds: 900));

    // Kembalikan null agar default-nya mengarah ke LoginScreen.
    // (Ubah ke return UserModel(...) jika ingin mengetes auto-login ke HomeScreen)
    return null;
  }

  @override
  Future<UserModel> register(UserModel user) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return user;
  }

  @override
  Future<UserModel> login(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (username == 'User' && password == '123456') {
      return UserModel(
        id: '1',
        username: username,
        email: 'user@teduh.id',
        firstName: 'User',
        lastName: 'Teduh',
        phoneNumber: '+6281234567890',
      );
    }
    throw Exception('Username atau password salah. (Demo: User / 123456)');
  }
}