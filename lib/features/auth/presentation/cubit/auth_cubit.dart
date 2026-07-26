import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import '../../domain/repositories/auth_repository.dart'; // تأكد من استيراد الـ Repository أو الـ UseCase المناسب
import '../../domain/usecases/login_usecase.dart';
import 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final AuthRepository _authRepository;

  AuthCubit(this._loginUseCase, this._authRepository) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());

    final result =
        await _loginUseCase(LoginParams(email: email, password: password));

    result.fold(
      onFailure: (failure) => emit(AuthError(failure.message)),
      onSuccess: (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());

    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      try {
        final userResult = await _authRepository.getUserData(session.user.id);

        userResult.fold(
          onFailure: (failure) => emit(AuthInitial()),
          onSuccess: (userEntity) => emit(AuthSuccess(userEntity)),
        );
      } catch (e) {
        emit(AuthInitial());
      }
    } else {
      emit(AuthInitial());
    }
  }
}
