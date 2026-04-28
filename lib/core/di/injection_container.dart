import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';
import '../../features/auth/data/auth_service.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  // Dio - single instance for the whole app
  sl.registerLazySingleton<Dio>(() => DioClient.getInstance());

  // Auth
  sl.registerLazySingleton<AuthService>(() => AuthService(sl<Dio>()));
}