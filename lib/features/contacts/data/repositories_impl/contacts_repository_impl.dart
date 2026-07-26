import 'package:injectable/injectable.dart';

import '../../../../core/error/api_result.dart'; // مسارك الجديد
import '../../../../core/error/exceptions.dart';
import '../../../../core/errors/failure.dart'; // تأكد من مسار الـ Failure
import '../../domain/entities/contact_entity.dart';
import '../../domain/repositories/contacts_repository.dart';
import '../datasources/contacts_remote_data_source.dart';
import '../models/contact_model.dart';

@Injectable(as: ContactsRepository)
class ContactsRepositoryImpl implements ContactsRepository {
  final ContactsRemoteDataSourceImpl remoteDataSource;

  ContactsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<List<ContactEntity>>> getContacts() async {
    try {
      final models = await remoteDataSource.getContacts();
      // الـ Model يرث من الـ Entity لذا يمكن تمريره مباشرة
      return Result.success(models);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(message: e.message));
    } catch (e) {
      return Result.failure(const ServerFailure(
          message: 'حدث خطأ غير متوقع أثناء جلب جهات الاتصال'));
    }
  }

  @override
  Future<Result<void>> addContact(ContactEntity contact,
      {String? password, String? email}) async {
    try {
      final model = ContactModel(
        id: contact.id,
        userId: contact.userId,
        name: contact.name,
        phone: contact.phone,
        area: contact.area,
        type: contact.type,
        openingBalance: contact.openingBalance,
        createdAt: contact.createdAt,
      );

      await remoteDataSource.addContact(model,
          email: email, password: password);
      // استخدام dynamic null كقيمة راجعة للـ void
      return Result.success(null);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(message: e.message));
    } catch (e) {
      return Result.failure(const ServerFailure(
          message: 'حدث خطأ غير متوقع أثناء إضافة جهة الاتصال'));
    }
  }

  @override
  Future<Result<void>> deleteContact(String id) async {
    try {
      await remoteDataSource.deleteContact(id);
      return Result.success(null);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(message: e.message));
    } catch (e) {
      return Result.failure(
          const ServerFailure(message: 'حدث خطأ غير متوقع أثناء الحذف'));
    }
  }

  @override
  Future<Result<void>> updateContact(ContactEntity contact) async {
    try {
      final model = ContactModel(
        id: contact.id,
        userId: contact.userId,
        name: contact.name,
        phone: contact.phone,
        area: contact.area,
        type: contact.type,
        openingBalance: contact.openingBalance,
        createdAt: contact.createdAt,
      );

      await remoteDataSource.updateContact(model);
      return Result.success(null);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(message: e.message));
    } catch (e) {
      return Result.failure(const ServerFailure(
          message: 'حدث خطأ غير متوقع أثناء تعديل بيانات الجهة'));
    }
  }
}
