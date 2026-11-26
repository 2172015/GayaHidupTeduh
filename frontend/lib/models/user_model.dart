class UserModel {
  final String id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String? description;
  final String? profilePicture;
  final String role;
  final DateTime? createdAt;

  // Hanya dipakai sementara saat payload register / dummy lokal
  final String? password;

  const UserModel({
    this.id = '',
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    this.description,
    this.profilePicture,
    this.role = 'user',
    this.createdAt,
    this.password,
  });

  /// Helper computed property (tidak perlu jadi kolom database)
  String get fullName => '$firstName $lastName'.trim();

  /// Untuk parsing response JSON dari Laravel nanti
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      description: json['description'],
      profilePicture: json['profile_picture'],
      role: json['role'] ?? 'user',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }

  /// Untuk mengirim data ke endpoint register Laravel nanti
  Map<String, dynamic> toRegisterJson() {
    return {
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      if (password != null) 'password': password,
      if (description != null) 'description': description,
      if (profilePicture != null) 'profile_picture': profilePicture,
    };
  }
}