enum UserRole { admin, patient}

class UserEntity {
  String? userId;
  String? firstName;
  String? lastName;
  String? email;
  UserRole? role;
  UserEntity({
    required this.userId,
    this.email,
    this.firstName,
    this.lastName,
    this.role,
  });
}
