import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  static const String noName = 'بدون اسم';
  static const String sales = 'sales';
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
      fullName: json['full_name'] ?? noName,
      role: json['role'] ?? sales,
    );
  }
}
