import '../../../../core/error/api_result.dart';
import '../entities/contact_entity.dart';

abstract class ContactsRepository {
  Future<Result<List<ContactEntity>>> getContacts();
  Future<Result<void>> addContact(ContactEntity contact,
      {String? password, String? email});
  Future<Result<void>> deleteContact(String id);
  // أضف هذا السطر داخل الـ abstract class
  Future<Result<void>> updateContact(ContactEntity contact);
}
