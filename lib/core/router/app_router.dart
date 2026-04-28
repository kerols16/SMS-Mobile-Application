import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:school_test/core/constants/routes_contents.dart';
import 'package:school_test/core/di/injection_container.dart';
import 'package:school_test/core/storage/local_srotage.dart';
import 'package:school_test/features/admin/admin_dashboard.dart';
import 'package:school_test/features/auth/data/auth_service.dart';
import 'package:school_test/features/auth/view/cubit/auth_cubit.dart';
import 'package:school_test/features/auth/view/login_screen.dart';
import 'package:school_test/features/parent/view/parent_dashboard.dart';
import 'package:school_test/features/student/view/student_dashboard.dart';
import 'package:school_test/features/teacher/view/teacher_dashboard.dart';

final GoRouter router = GoRouter(
  initialLocation: Routes.login,

  redirect: (context, state) async {
    final token = await LocalStorage.getToken();
    final isLoggedIn = token != null;
    final isOnLogin = state.matchedLocation == Routes.login;

    if (!isLoggedIn && !isOnLogin) return Routes.login;
    if (isLoggedIn && isOnLogin) {
      final role = await LocalStorage.getRole();
      return '/$role';
    }
    return null;
  },

  routes: [
    GoRoute(
      path: Routes.login,
      builder: (context, state) => BlocProvider(
        create: (_) => AuthCubit(sl<AuthService>()),
        child: const LoginScreen(),
      ),
    ),
    GoRoute(
      path: Routes.admin,
      builder: (context, state) => const AdminDashboard(),
    ),
    GoRoute(
      path: Routes.teacher,
      builder: (context, state) => const TeacherDashboard(),
    ),
    GoRoute(
      path: Routes.student,
      builder: (context, state) => const StudentDashboard(),
    ),
    GoRoute(
      path: Routes.parent,
      builder: (context, state) => const ParentDashboard(),
    ),
  ],
);