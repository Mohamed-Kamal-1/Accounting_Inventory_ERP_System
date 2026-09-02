import '../../domain/entities/purchases_history_entity.dart';

abstract class PurchasesHistoryState {}

class PurchasesHistoryInitial extends PurchasesHistoryState {}

class PurchasesHistoryLoading extends PurchasesHistoryState {}

class PurchasesHistoryLoaded extends PurchasesHistoryState {
  final List<PurchasesHistoryEntity> invoices;
  PurchasesHistoryLoaded(this.invoices);
}

class PurchasesHistoryError extends PurchasesHistoryState {
  final String message;
  PurchasesHistoryError(this.message);
}

class PurchasesHistoryPdfLoading extends PurchasesHistoryState {}

class PurchasesHistoryPdfSuccess extends PurchasesHistoryState {}
