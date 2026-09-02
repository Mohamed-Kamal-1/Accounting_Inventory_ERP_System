abstract class PurchasesState {}

class PurchasesInitial extends PurchasesState {}

class PurchasesLoading extends PurchasesState {}

class PurchasesSuccess extends PurchasesState {}

class PurchasesUpdated extends PurchasesState {}

class PurchasesError extends PurchasesState {
  final String message;
  PurchasesError(this.message);
}
