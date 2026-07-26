import 'package:equatable/equatable.dart';

class SalesmanCustodyEntity extends Equatable {
  final String salesmanId;
  final String productId;
  final String productName;
  final int currentQty;

  const SalesmanCustodyEntity({
    required this.salesmanId,
    required this.productId,
    required this.productName,
    required this.currentQty,
  });

  @override
  List<Object?> get props => [salesmanId, productId, productName, currentQty];
}
