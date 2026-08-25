import 'package:equatable/equatable.dart';

class InvoiceHeaderEntity extends Equatable {
  final String id;
  final DateTime createdAt;
  final String invoiceType;
  final double subTotal;
  final double discount;
  final double grandTotal;
  final double paidAmount;
  final double remainingAmount;
  final String contactId;
  final String contactName;

  const InvoiceHeaderEntity({
    required this.id,
    required this.createdAt,
    required this.invoiceType,
    required this.subTotal,
    required this.discount,
    required this.grandTotal,
    required this.paidAmount,
    required this.remainingAmount,
    required this.contactId,
    required this.contactName,
  });

  @override
  List<Object?> get props => [
        id,
        createdAt,
        invoiceType,
        subTotal,
        discount,
        grandTotal,
        paidAmount,
        remainingAmount,
        contactId,
        contactName,
      ];
}
