import '../../domain/entities/treasury_transaction_entity.dart';

class TreasuryTransactionModel extends TreasuryTransactionEntity {
  const TreasuryTransactionModel({
    required super.id,
    required super.createdAt,
    required super.transactionType,
    required super.amount,
    required super.description,
    super.referenceId,
  });

  factory TreasuryTransactionModel.fromJson(Map<String, dynamic> json) {
    return TreasuryTransactionModel(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      transactionType: json['transaction_type'],
      amount: double.parse(json['amount'].toString()),
      description: json['description'] ?? '',
      referenceId: json['reference_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction_type': transactionType,
      'amount': amount,
      'description': description,
      if (referenceId != null) 'reference_id': referenceId,
    };
  }
}
