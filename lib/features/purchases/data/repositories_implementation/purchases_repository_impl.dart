import 'package:injectable/injectable.dart';

import '../../domain/entities/purchase_invoice_entity.dart';
import '../../domain/repositories/purchases_repository.dart';
import '../datasources/purchases_remote_datasource.dart';
import '../models/purchase_invoice_model.dart';

@Singleton(as: PurchasesRepository)
class PurchasesRepositoryImpl implements PurchasesRepository {
  final PurchasesRemoteDataSource _remoteDataSource;

  PurchasesRepositoryImpl(this._remoteDataSource);

  @override
  Future<void> savePurchaseInvoice(PurchaseInvoiceEntity invoice) async {
    final invoiceModel = PurchaseInvoiceModel.fromEntity(invoice);

    final invoiceData = invoiceModel.toJson();
    final itemsData = invoiceModel.items
        .map((item) => PurchaseItemModel.fromEntity(item).toJson())
        .toList();

    await _remoteDataSource.createPurchaseInvoice(invoiceData, itemsData);
  }
}
