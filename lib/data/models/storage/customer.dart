import 'package:admin_panel/domain/entities/user.dart';

class UserModel {
  final String? userId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final UserRole? role;

  UserModel({
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.role,
  });

  /// create a model from your entity
  factory UserModel.fromEntity(UserEntity e) {
    return UserModel(
      userId: e.userId,
      firstName: e.firstName,
      lastName: e.lastName,
      email: e.email,
      role: e.role,
    );
  }

  /// optional: JSON serialization
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    userId: json['userId'] as String?,
    firstName: json['firstName'] as String?,
    lastName: json['lastName'] as String?,
    email: json['email'] as String?,
    role:
        json['role'] != null
            ? UserRole.values.firstWhere((r) => r.toString() == json['role'])
            : null,
  );

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'role': role?.toString(),
  };
}

/// convert back into an entity
extension UserModelX on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      email: email,
      role: role,
    );
  }
}
