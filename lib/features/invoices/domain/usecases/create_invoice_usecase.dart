import 'package:injectable/injectable.dart';

import '../entities/invoice_entity.dart';
import '../repositories/invoices_repository.dart';

@injectable
class CreateInvoiceUseCase {
  final InvoicesRepository repository;

  CreateInvoiceUseCase(this.repository);

  Future<void> call(InvoiceEntity invoice) async {
    return await repository.createInvoice(invoice);
  }
}
