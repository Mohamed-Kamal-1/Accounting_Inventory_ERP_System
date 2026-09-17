import 'package:equatable/equatable.dart';

class TreasuryTransactionEntity extends Equatable {
  final String id;
  final DateTime createdAt;
  final String transactionType;
  final double amount;
  final String description;
  final String? referenceId;

  const TreasuryTransactionEntity({
    required this.id,
    required this.createdAt,
    required this.transactionType,
    required this.amount,
    required this.description,
    this.referenceId,
  });

  bool get isIncome =>
      transactionType == 'sales_receipt' ||
      transactionType == 'manual_deposit' ||
      transactionType == 'purchase_return' ||
      transactionType.contains('sales') ||
      description.contains('تحصيل') ||
      description.contains('بيع');

  @override
  List<Object?> get props =>
      [id, createdAt, transactionType, amount, description, referenceId];
}
