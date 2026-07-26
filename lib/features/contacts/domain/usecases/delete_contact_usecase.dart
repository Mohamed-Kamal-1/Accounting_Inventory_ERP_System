import 'package:injectable/injectable.dart';

import '../../../../core/error/api_result.dart';
import '../repositories/contacts_repository.dart';

@injectable
class DeleteContactUseCase {
  final ContactsRepository repository;

  DeleteContactUseCase(this.repository);

  Future<Result<void>> call(String id) {
    return repository.deleteContact(id);
  }
}
