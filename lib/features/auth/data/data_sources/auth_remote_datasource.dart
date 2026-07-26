import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;

import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

//
@injectable
class AuthRemoteDataSourceImpl {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw const AuthException(message: 'فشل تسجيل الدخول');
      }

      final profileData = await supabaseClient
          .from('profiles')
          .select()
          .eq('id', response.user!.id)
          .single();

      return UserModel(
        id: response.user!.id,
        email: response.user!.email ?? '',
        fullName: profileData['full_name'] ?? 'unkown',
        role: profileData['role'],
      );
    } on AuthException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'حدث خطأ غير متوقع: ${e.toString()}');
    }
  }
}
