import '../../domain/entities/contact_entity.dart';

class ContactModel extends ContactEntity {
  const ContactModel({
    required super.id,
    super.userId,
    required super.name,
    required super.phone,
    required super.area,
    required super.type,
    required super.openingBalance,
    required super.createdAt,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'] as String,
      userId: json['user_id'] as String?,
      name: json['name'] as String,
      phone: json['phone'] as String,
      area: json['area'] ?? '',
      type: json['type'] as String,
      openingBalance: (json['opening_balance'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'area': area,
      'type': type,
      'opening_balance': openingBalance,
      if (userId != null) 'user_id': userId,
    };
  }
}
