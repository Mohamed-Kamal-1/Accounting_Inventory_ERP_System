import 'package:equatable/equatable.dart';

class ContactEntity extends Equatable {
  final String id;
  final String? userId;
  final String name;
  final String phone;
  final String area;
  final String type;
  final double openingBalance;
  final DateTime createdAt;

  const ContactEntity({
    required this.id,
    this.userId,
    required this.name,
    required this.phone,
    required this.area,
    required this.type,
    required this.openingBalance,
    required this.createdAt,
  });

  @override
  List<Object?> get props =>
      [id, userId, name, phone, area, type, openingBalance, createdAt];
}
