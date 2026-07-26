import 'package:injectable/injectable.dart';

import '../../../../core/error/api_result.dart';
import '../entities/contact_entity.dart';
import '../repositories/contacts_repository.dart';

@injectable
class GetContactsUseCase {
  final ContactsRepository repository;

  GetContactsUseCase(this.repository);

  Future<Result<List<ContactEntity>>> call() {
    return repository.getContacts();
  }
}
