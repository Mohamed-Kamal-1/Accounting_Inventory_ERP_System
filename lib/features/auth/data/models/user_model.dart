import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.fullName,
    required super.role,
  });

  factory UserModel.fromJson(
      Map<String, dynamic> json, String id, String email) {
    return UserModel(
      id: id,
      email: email,
      fullName: json['full_name'] ?? 'بدون اسم',
      role: json['role'] ?? 'sales',
    );
  }
}
