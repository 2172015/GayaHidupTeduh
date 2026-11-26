import 'user_gender.dart';

class UserProfile {
  final String id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final UserGender gender;
  final String description;
  final String avatarAsset;

  const UserProfile({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    this.gender = UserGender.preferNotToSay,
    this.description = '',
    this.avatarAsset = 'assets/images/profilepicture/male_1.jpg',
  });

  String get fullName => '$firstName $lastName'.trim();

  UserProfile copyWith({
    String? id,
    String? username,
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    UserGender? gender,
    String? description,
    String? avatarAsset,
  }) {
    return UserProfile(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      description: description ?? this.description,
      avatarAsset: avatarAsset ?? this.avatarAsset,
    );
  }
}
