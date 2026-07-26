import 'package:equatable/equatable.dart';

class InventoryTransactionEntity extends Equatable {
  final String id;
  final String productId;
  final String productName;
  final String type;
  final int quantity;
  final DateTime createdAt;
  final String? notes;

  const InventoryTransactionEntity({
    required this.id,
    required this.productId,
    required this.productName,
    required this.type,
    required this.quantity,
    required this.createdAt,
    this.notes,
  });

  @override
  List<Object?> get props =>
      [id, productId, productName, type, quantity, createdAt, notes];
}
