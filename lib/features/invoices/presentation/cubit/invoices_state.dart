abstract class InvoicesState {
  const InvoicesState();
}

class InvoicesInitial extends InvoicesState {}

class InvoicesLoading extends InvoicesState {}

class InvoicesSuccess extends InvoicesState {}

class InvoicesError extends InvoicesState {
  final String message;
  const InvoicesError(this.message);
}
