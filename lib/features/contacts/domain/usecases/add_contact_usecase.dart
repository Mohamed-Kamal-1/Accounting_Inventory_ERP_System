import 'package:injectable/injectable.dart';

import '../../../../core/error/api_result.dart';
import '../entities/contact_entity.dart';
import '../repositories/contacts_repository.dart';

@injectable
class AddContactUseCase {
  final ContactsRepository repository;

  AddContactUseCase(this.repository);

  Future<Result<void>> call(ContactEntity contact,
      {String? email, String? password}) {
    return repository.addContact(contact, email: email, password: password);
  }
}
