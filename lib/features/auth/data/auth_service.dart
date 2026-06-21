import 'package:dio/dio.dart';
import 'package:school_test/core/storage/local_srotage.dart';
import '../../../../core/constants/api_constants.dart';
import 'auth_model.dart';

class AuthService {
  final Dio _dio;
  AuthService(this._dio);

  Future<UserModel> login(String email, String password) async {

    final response = await _dio.post(
      ApiConstants.authLogin,
      data: {
        'email':    email,
        'password': password,
      },
    );
    return UserModel.fromJson(response.data);
  }

  Future<void> logout() async {
    await _dio.post(ApiConstants.authLogout);
  }
}