import 'package:accounting_desktop/features/purchases_history/presentation/cubit/purchases_history_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/utils/pdf_export_helper.dart';
import '../../domain/entities/purchases_history_entity.dart';
import '../../domain/repositories/purchases_history_repository.dart';

@injectable
class PurchasesHistoryCubit extends Cubit<PurchasesHistoryState> {
  final PurchasesHistoryRepository _purchasesHistoryRepository;

  PurchasesHistoryCubit(this._purchasesHistoryRepository)
      : super(PurchasesHistoryInitial());

  List<PurchasesHistoryEntity> currentInvoices = [];

  Future<void> fetchHistory() async {
    emit(PurchasesHistoryLoading());
    try {
      currentInvoices = await _purchasesHistoryRepository.getPurchasesHistory();
      emit(PurchasesHistoryLoaded(currentInvoices));
    } catch (e) {
      emit(PurchasesHistoryError("خطأ في جلب السجل: ${e.toString()}"));
    }
  }

  // تصدير PDF منفصل وخالٍ من الـ UI Logic
  Future<void> exportInvoicePdf(PurchasesHistoryEntity invoice) async {
    emit(PurchasesHistoryPdfLoading());
    try {
      final itemsMap = invoice.items
          .map((e) => {
                'name': e.productName,
                'quantity': e.quantity,
                'unit_price': e.unitPrice,
                'total_price': e.totalPrice,
              })
          .toList();

      await PdfExportHelper.generateAndSaveInvoice(
        invoiceId: invoice.id.substring(0, 8).toUpperCase(),
        date: invoice.createdAt,
        supplierName: invoice.supplierName,
        items: itemsMap,
        subTotal: invoice.subTotal,
        discount: invoice.discount,
        grandTotal: invoice.grandTotal,
        paid: invoice.paidAmount,
        remaining: invoice.remainingAmount,
      );

      emit(PurchasesHistoryPdfSuccess());
    } catch (e) {
      emit(PurchasesHistoryError("خطأ في استخراج الـ PDF: $e"));
    }
    emit(PurchasesHistoryLoaded(currentInvoices));
  }
}
