enum UserRole { patient, guardian }

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String password;
  final UserRole role;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.role,
  });
}
