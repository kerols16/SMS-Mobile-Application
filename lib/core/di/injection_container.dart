import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:school_test/features/admin/data/admin_service.dart';
import 'package:school_test/features/admin/veiw_model/cubit/admin_cubit.dart';
import 'package:school_test/features/teacher/data/teacher_service.dart';
import 'package:school_test/features/teacher/view_model/cubit/teacher_cubit.dart';
import 'package:school_test/features/student/data/student_service.dart';
import 'package:school_test/features/student/view_model/cubit/student_cubit.dart';
import '../network/dio_client.dart';
import '../../features/auth/data/auth_service.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  // Dio - single instance for the whole app
  sl.registerLazySingleton<Dio>(() => DioClient.getInstance());
  
  // Auth
  sl.registerLazySingleton<AuthService>(() => AuthService(sl<Dio>()));

  // Admin
  sl.registerLazySingleton<AdminService>(() => AdminService(sl<Dio>()));
  sl.registerFactory<AdminCubit>(() => AdminCubit(sl<AdminService>()));

  // Teacher
  sl.registerLazySingleton<TeacherService>(() => TeacherService(sl<Dio>()));
  sl.registerFactory<TeacherCubit>(() => TeacherCubit(sl<TeacherService>()));

  //  Student
  sl.registerLazySingleton<StudentService>(() => StudentService(sl<Dio>()));
  sl.registerFactory<StudentCubit>(() => StudentCubit(sl<StudentService>()));
}