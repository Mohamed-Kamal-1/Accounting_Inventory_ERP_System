import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/repositories/sales_history_repository.dart';
import 'sales_history_state.dart';

@injectable
class SalesHistoryCubit extends Cubit<SalesHistoryState> {
  final SalesHistoryRepository repository;

  int _offset = 0;
  final int _limit = 20;
  String _currentSearchTerm = '';
  Timer? _debounceTimer;

  bool _isFetching = false;

  DateTime? _startDate;
  DateTime? _endDate;

  SalesHistoryCubit({required this.repository})
      : super(const SalesHistoryState());

  void fetchInvoices({bool isRefresh = false}) async {
    if (_isFetching) return;
    if (!isRefresh && state.hasReachedMax) return;

    _isFetching = true;

    if (isRefresh) {
      _offset = 0;
      emit(state.copyWith(
          status: SalesHistoryStatus.loading,
          hasReachedMax: false,
          invoices: []));
    }

    try {
      final result = await repository.getSalesHistory(
        searchTerm: _currentSearchTerm,
        startDate: _startDate,
        endDate: _endDate,
        limit: _limit,
        offset: _offset,
      );

      result.fold(
        onFailure: (failure) {
          _isFetching = false;
          emit(state.copyWith(
            status: SalesHistoryStatus.failure,
            errorMessage: failure.message,
          ));
        },
        onSuccess: (data) {
          _isFetching = false;
          if (data.isEmpty) {
            emit(state.copyWith(
              status: SalesHistoryStatus.success,
              hasReachedMax: true,
            ));
          } else {
            _offset += _limit;
            final updatedInvoices =
                isRefresh ? data : [...state.invoices, ...data];
            emit(state.copyWith(
              status: SalesHistoryStatus.success,
              invoices: updatedInvoices,
              hasReachedMax: data.length < _limit,
            ));
          }
        },
      );
    } catch (e) {
      _isFetching = false;
      emit(state.copyWith(
        status: SalesHistoryStatus.failure,
        errorMessage: 'حدث خطأ غير متوقع: $e',
      ));
    }
  }

  void searchInvoices(String query) {
    _currentSearchTerm = query;
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _isFetching = false;
      fetchInvoices(isRefresh: true);
    });
  }

  void setDateFilter(DateTime? start, DateTime? end) {
    _startDate = start;
    _endDate = end;
    _isFetching = false;
    fetchInvoices(isRefresh: true);
  }

  void clearDateFilter() {
    _startDate = null;
    _endDate = null;
    _isFetching = false;
    fetchInvoices(isRefresh: true);
  }

  void fetchInvoiceDetails(String invoiceId) async {
    emit(state.copyWith(detailsStatus: InvoiceDetailsStatus.loading));
    final result = await repository.getInvoiceDetails(invoiceId);

    result.fold(
      onFailure: (failure) => emit(state.copyWith(
          detailsStatus: InvoiceDetailsStatus.failure,
          detailsErrorMessage: failure.message)),
      onSuccess: (data) => emit(state.copyWith(
          detailsStatus: InvoiceDetailsStatus.success,
          selectedInvoiceDetails: data)),
    );
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
