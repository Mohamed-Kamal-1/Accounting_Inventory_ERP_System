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

      // إذا كان المدخل موظفاً، نقوم بإنشاء حساب له أولاً في نظام Supabase Auth
      if ((contact.type == 'sales' ||
              contact.type == 'preview' ||
              contact.type == 'technician') &&
          email != null &&
          password != null) {
        // استخدام ميزة signUp لإنشاء الحساب
        final authResponse = await supabaseClient.auth.signUp(
          email: email,
          password: password,
          data: {'full_name': contact.name, 'role': contact.type},
        );

        if (authResponse.user == null) {
          throw const ServerException(
              message: 'فشل إنشاء حساب الموظف في النظام');
        }
        createdUserId = authResponse.user!.id;
      }

      // إضافة الجهة إلى جدول contacts وربطها بالـ user_id إن وجد
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

  // أضف هذه الدالة داخل الـ Impl
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
