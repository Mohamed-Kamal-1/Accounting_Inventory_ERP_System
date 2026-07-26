import 'package:injectable/injectable.dart';

import '../../../../core/error/api_result.dart';
import '../entities/contact_entity.dart';
import '../repositories/contacts_repository.dart';

@injectable
class UpdateContactUseCase {
  final ContactsRepository repository;

  UpdateContactUseCase(this.repository);

  Future<Result<void>> call(ContactEntity contact) {
    return repository.updateContact(contact);
  }
}
