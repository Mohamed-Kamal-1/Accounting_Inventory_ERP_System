import 'package:equatable/equatable.dart';

import '../../../../sales_history/domain/entities/invoice_details_entity.dart';
import '../../../../sales_history/domain/entities/invoice_header_entity.dart';

enum SalesHistoryStatus { initial, loading, success, failure }

enum InvoiceDetailsStatus { initial, loading, success, failure }

class SalesHistoryState extends Equatable {
  // حالة قائمة الفواتير الرئيسية
  final SalesHistoryStatus status;
  final List<InvoiceHeaderEntity> invoices;
  final bool hasReachedMax; // هل وصلنا لنهاية الفواتير في السيرفر؟
  final String errorMessage;

  // حالة تفاصيل فاتورة محددة (للطباعة)
  final InvoiceDetailsStatus detailsStatus;
  final List<InvoiceDetailsEntity> selectedInvoiceDetails;
  final String detailsErrorMessage;

  const SalesHistoryState({
    this.status = SalesHistoryStatus.initial,
    this.invoices = const [],
    this.hasReachedMax = false,
    this.errorMessage = '',
    this.detailsStatus = InvoiceDetailsStatus.initial,
    this.selectedInvoiceDetails = const [],
    this.detailsErrorMessage = '',
  });

  SalesHistoryState copyWith({
    SalesHistoryStatus? status,
    List<InvoiceHeaderEntity>? invoices,
    bool? hasReachedMax,
    String? errorMessage,
    InvoiceDetailsStatus? detailsStatus,
    List<InvoiceDetailsEntity>? selectedInvoiceDetails,
    String? detailsErrorMessage,
  }) {
    return SalesHistoryState(
      status: status ?? this.status,
      invoices: invoices ?? this.invoices,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
      detailsStatus: detailsStatus ?? this.detailsStatus,
      selectedInvoiceDetails:
          selectedInvoiceDetails ?? this.selectedInvoiceDetails,
      detailsErrorMessage: detailsErrorMessage ?? this.detailsErrorMessage,
    );
  }

  @override
  List<Object> get props => [
        status,
        invoices,
        hasReachedMax,
        errorMessage,
        detailsStatus,
        selectedInvoiceDetails,
        detailsErrorMessage,
      ];
}
