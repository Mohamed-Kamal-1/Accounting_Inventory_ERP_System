// lib/core/network/execute_supabase.dart
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../error/exceptions.dart';
import '../error/failure.dart';
import '../error/result.dart';

Future<Result<T>> executeSupabase<T>(Future<T> Function() apiCall) async {
  try {
    final response = await apiCall();
    return Result.success(response);
  } on ServerException catch (e) {
    return Result.failure(ServerFailure(message: e.message));
  } on AppAuthException catch (e) {
    return Result.failure(AuthFailure(message: e.message));
  } on CacheException catch (e) {
    return Result.failure(CacheFailure(message: e.message));
  } on NotFoundException catch (e) {
    return Result.failure(NotFoundFailure(message: e.message));
  } on supabase.PostgrestException catch (e) {
    return Result.failure(ServerFailure(message: e.message));
  } on supabase.AuthException catch (e) {
    return Result.failure(AuthFailure(message: e.message));
  } catch (e) {
    return Result.failure(ServerFailure(message: 'حدث خطأ غير متوقع: $e'));
  }
}
