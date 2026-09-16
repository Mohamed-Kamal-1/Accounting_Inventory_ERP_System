import 'package:accounting_desktop/features/purchases/presentation/cubit/purchase_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/di/di.dart';
import '../../../reports_and_dashboard/presentation/cubit/reports_cubit.dart';
import '../../data/datasources/purchases_remote_datasource.dart';

@injectable
class PurchasesCubit extends Cubit<PurchasesState> {
  final PurchasesRemoteDataSource _remoteDataSource;

  PurchasesCubit(this._remoteDataSource) : super(PurchasesInitial());

  List<Map<String, dynamic>> allProducts = [];
  List<Map<String, dynamic>> allContacts = [];
  List<Map<String, dynamic>> filteredContacts = [];
  String? selectedContactType;

  String? selectedSupplierId;
  List<Map<String, dynamic>> invoiceItems = [];

  double subTotal = 0.0;
  double discount = 0.0;
  double grandTotal = 0.0;
  double paidAmount = 0.0;
  double remainingAmount = 0.0;

  Future<void> loadInitialData() async {
    emit(PurchasesLoading());
    try {
      final supabase = Supabase.instance.client;

      final contactsRes =
          await supabase.from('contacts').select('id, name, type');
      allContacts = List<Map<String, dynamic>>.from(contactsRes);

      final productsRes =
          await supabase.from('products').select('id, name, purchase_price');
      allProducts = List<Map<String, dynamic>>.from(productsRes);

      filterContactsByType('supplier');
    } catch (e) {
      emit(PurchasesError("خطأ في جلب البيانات: ${e.toString()}"));
    }
  }

  void filterContactsByType(String type) {
    selectedContactType = type;
    selectedSupplierId = null;
    filteredContacts = allContacts.where((c) => c['type'] == type).toList();
    emit(PurchasesUpdated());
  }

  void addProductToInvoice(
      String productId, String name, double price, int qty) {
    final existingIndex =
        invoiceItems.indexWhere((item) => item['product_id'] == productId);
    if (existingIndex >= 0) {
      invoiceItems[existingIndex]['quantity'] += qty;
      invoiceItems[existingIndex]['total_price'] =
          invoiceItems[existingIndex]['quantity'] * price;
    } else {
      invoiceItems.add({
        'product_id': productId,
        'name': name,
        'quantity': qty,
        'unit_price': price,
        'total_price': price * qty,
      });
    }
    _calculateTotals();
  }

  void removeProduct(int index) {
    invoiceItems.removeAt(index);
    _calculateTotals();
  }

  void updateDiscount(double value) {
    discount = value;
    _calculateTotals();
  }

  void updatePaidAmount(double value) {
    paidAmount = value;
    _calculateTotals();
  }

  void selectSupplier(String supplierId) {
    selectedSupplierId = supplierId;
    emit(PurchasesUpdated());
  }

  void _calculateTotals() {
    subTotal = invoiceItems.fold(0.0, (sum, item) => sum + item['total_price']);
    grandTotal = subTotal - discount;
    remainingAmount = grandTotal - paidAmount;
    emit(PurchasesUpdated());
  }

  Future<void> saveInvoice() async {
    if (selectedSupplierId == null) {
      emit(PurchasesError("يرجى اختيار المورد أولاً"));
      return;
    }
    if (invoiceItems.isEmpty) {
      emit(PurchasesError("الفاتورة فارغة، أضف منتجات"));
      return;
    }
    if (getIt.isRegistered<ReportsCubit>()) {
      getIt<ReportsCubit>().loadDashboardStats();
    }
    emit(PurchasesLoading());
    try {
      final invoiceData = {
        'contact_id': selectedSupplierId,
        'sub_total': subTotal,
        'discount': discount,
        'grand_total': grandTotal,
        'paid_amount': paidAmount,
        'remaining_amount': remainingAmount,
        'total_amount': grandTotal,
        'status': remainingAmount > 0 ? 'partial' : 'paid',
      };

      final itemsData = invoiceItems
          .map((e) => {
                'product_id': e['product_id'],
                'quantity': e['quantity'],
                'unit_price': e['unit_price'],
                'total_price': e['total_price'],
              })
          .toList();

      await _remoteDataSource.createPurchaseInvoice(invoiceData, itemsData);
      emit(PurchasesSuccess());
    } catch (e) {
      emit(PurchasesError(e.toString()));
    }
  }

  void resetInvoice() {
    selectedSupplierId = null;
    invoiceItems.clear();
    subTotal = 0.0;
    discount = 0.0;
    grandTotal = 0.0;
    paidAmount = 0.0;
    remainingAmount = 0.0;
    emit(PurchasesUpdated());
  }
}
