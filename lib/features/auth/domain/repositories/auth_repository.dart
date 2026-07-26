import '../../../../core/error/api_result.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Result<UserEntity>> login(
      {required String email, required String password});
  Future<void> logout();
  Future<Result<UserEntity>> getUserData(String uid);
}
