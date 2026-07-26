import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/invoice_entity.dart';
import '../../domain/usecases/create_invoice_usecase.dart';
import 'invoices_state.dart';

@injectable
class InvoicesCubit extends Cubit<InvoicesState> {
  final CreateInvoiceUseCase _createInvoiceUseCase;

  InvoicesCubit(this._createInvoiceUseCase) : super(InvoicesInitial());

  Future<void> saveInvoice(InvoiceEntity invoice) async {
    emit(InvoicesLoading());
    try {
      await _createInvoiceUseCase(invoice);
      emit(InvoicesSuccess());
    } catch (e) {
      emit(InvoicesError(e.toString()));
    }
  }
}
