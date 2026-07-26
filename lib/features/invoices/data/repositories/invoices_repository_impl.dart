import 'package:injectable/injectable.dart';

import '../../domain/entities/invoice_entity.dart';
import '../../domain/repositories/invoices_repository.dart';
import '../datasources/invoices_remote_datasource.dart';
import '../models/invoice_item_model.dart';

@Singleton(as: InvoicesRepository)
class InvoicesRepositoryImpl implements InvoicesRepository {
  final InvoicesRemoteDataSource _remoteDataSource;

  InvoicesRepositoryImpl(this._remoteDataSource);

  @override
  Future<void> createInvoice(InvoiceEntity invoice) async {
    final jsonItems = invoice.items.map((item) {
      return InvoiceItemModel(
        productId: item.productId,
        productName: item.productName,
        quantity: item.quantity,
        price: item.price,
      ).toJson();
    }).toList();

    final params = {
      'p_id': invoice.id,
      'p_type': invoice.type,
      'p_account_id': invoice.accountId,
      'p_rep_id': invoice.repId,
      'p_date': invoice.date,
      'p_total': invoice.total,
      'p_items': jsonItems,
    };

    await _remoteDataSource.executeInvoiceRpc(params);
  }
}
