import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../models/contact_model.dart';

@injectable
class ContactsRemoteDataSourceImpl {
  final SupabaseClient supabaseClient;

  ContactsRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<ContactModel>> getContacts() async {
    try {
      final response = await supabaseClient
          .from('contacts')
          .select()
          .order('created_at', ascending: false);
      return (response as List)
          .map((json) => ContactModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerException(message: 'فشل جلب جهات الاتصال: ${e.toString()}');
    }
  }

  @override
  Future<void> addContact(ContactModel contact,
      {String? email, String? password}) async {
    try {
      String? createdUserId;

      if ((contact.type == 'sales' ||
              contact.type == 'preview' ||
              contact.type == 'technician') &&
          email != null &&
          password != null) {
        final response = await supabaseClient.rpc('admin_create_user', params: {
          'p_email': email,
          'p_password': password,
          'p_full_name': contact.name,
          'p_role': contact.type,
        });

        createdUserId = response as String;
      }

      final finalContact = ContactModel(
        id: contact.id,
        userId: createdUserId,
        name: contact.name,
        phone: contact.phone,
        area: contact.area,
        type: contact.type,
        openingBalance: contact.openingBalance,
        createdAt: contact.createdAt,
      );

      await supabaseClient.from('contacts').insert(finalContact.toJson());
    } catch (e) {
      throw ServerException(message: 'فشل حفظ جهة الاتصال: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteContact(String id) async {
    try {
      await supabaseClient.from('contacts').delete().eq('id', id);
    } catch (e) {
      throw ServerException(message: 'فشل حذف جهة الاتصال');
    }
  }

  @override
  Future<void> updateContact(ContactModel contact) async {
    try {
      // نحن نعدل البيانات الأساسية فقط، ولا نعدل الرصيد الافتتاحي أو النوع لتجنب الكوارث المحاسبية
      await supabaseClient.from('contacts').update({
        'name': contact.name,
        'phone': contact.phone,
        'area': contact.area,
      }).eq('id', contact.id);
    } catch (e) {
      throw ServerException(message: 'فشل تعديل جهة الاتصال: ${e.toString()}');
    }
  }
}
