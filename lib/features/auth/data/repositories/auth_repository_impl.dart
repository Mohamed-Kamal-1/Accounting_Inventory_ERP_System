import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/api_result.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/execute_supabase.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_remote_datasource.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final client = Supabase.instance.client;
  final AuthRemoteDataSourceImpl remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<UserEntity>> login(
      {required String email, required String password}) async {
    try {
      final userModel = await remoteDataSource.login(email, password);
      return Result.success(userModel);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(message: e.message));
    } catch (e) {
      return Result.failure(
          ServerFailure(message: 'حدث خطأ غير متوقع أثناء تسجيل الدخول'));
    }
  }

  @override
  Future<void> logout() async {
    await client.auth.signOut();
  }

  @override
  Future<Result<UserEntity>> getUserData(String uid) async {
    return executeSupabase(() async {
      // ⚠️ التعديل هنا: استخدام جدول profiles بدلاً من users
      final response =
          await client.from('profiles').select().eq('id', uid).single();

      return UserEntity(
        id: response['id'] ?? uid,
        email: response['email'] ?? '',
        fullName: response['full_name'] ?? 'unknown',
        role: response['role'] ?? 'rep',
      );
    });
  }
}
