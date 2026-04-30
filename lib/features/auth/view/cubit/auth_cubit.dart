import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_test/core/storage/local_srotage.dart';
import '../../data/auth_model.dart';
import '../../data/auth_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;
  AuthCubit(this._authService) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _authService.login(email, password);

      await LocalStorage.saveToken(user.token);
      await LocalStorage.saveToken(user.token);
      await LocalStorage.saveOriginalRole(user.role);

      // super_admin → save as admin for routing
      final roleToSave = user.role == 'super_admin' ? 'admin' : user.role;
      await LocalStorage.saveRole(roleToSave);

      emit(AuthSuccess(user));
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        emit(AuthError('Invalid email or password'));
      } else if (e.type == DioExceptionType.connectionTimeout) {
        emit(AuthError('Connection timeout, please try again'));
      } else if (e.type == DioExceptionType.unknown) {
        emit(AuthError('No internet connection'));
      } else {
        emit(AuthError('Something went wrong, please try again'));
      }
    } catch (e) {
      emit(AuthError('Something went wrong, please try again'));
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    await LocalStorage.clear();
    emit(AuthInitial());
  }
}
