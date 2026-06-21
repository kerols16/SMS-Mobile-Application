import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:school_test/core/constants/routes_contents.dart';
import 'package:school_test/core/di/injection_container.dart';
import 'package:school_test/core/storage/local_srotage.dart';
import 'package:school_test/features/admin/data/admin_service.dart';
import 'package:school_test/features/admin/view/pages/admin_dashboard.dart';
import 'package:school_test/features/admin/view/pages/classroom_details_page.dart';
import 'package:school_test/features/admin/view/pages/subject_details_page.dart';
import 'package:school_test/features/admin/view/pages/schedule_details_page.dart';
import 'package:school_test/features/admin/view/pages/user_details_page.dart';
import 'package:school_test/features/admin/veiw_model/cubit/admin_cubit.dart';
import 'package:school_test/features/auth/data/auth_service.dart';
import 'package:school_test/features/auth/view_model/cubit/auth_cubit.dart';
import 'package:school_test/features/auth/view/login_screen.dart';
import 'package:school_test/features/parent/view/parent_dashboard.dart';
import 'package:school_test/features/student/view/screens/student_dashboard.dart';
import 'package:school_test/features/student/view_model/cubit/student_cubit.dart'; // ✅ import
import 'package:school_test/features/student/data/student_service.dart'; // ✅ import
import 'package:school_test/features/teacher/view/teacher_dashboard.dart';
import 'package:school_test/features/splash/splash_screen.dart';

final GlobalKey<NavigatorState> routerNavigatorKey =
    GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: routerNavigatorKey,
  initialLocation: '/splash',

  redirect: (context, state) async {
    if (state.matchedLocation == '/splash') return null;

    final token = await LocalStorage.getToken();
    final isLoggedIn = token != null;
    final isOnLogin = state.matchedLocation == Routes.login;

    if (!isLoggedIn && !isOnLogin) return Routes.login;

    if (isLoggedIn && isOnLogin) {
      final role = await LocalStorage.getRole();
      if (role == 'admin' || role == 'super_admin') return Routes.admin;
      return '/$role';
    }
    return null;
  },

  routes: [
    // ── Splash ───────────────────────────────────────────────────
    GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),

    // ── Login ────────────────────────────────────────────────────
    GoRoute(
      path: Routes.login,
      builder: (_, __) => BlocProvider(
        create: (_) => AuthCubit(sl<AuthService>()),
        child: const LoginScreen(),
      ),
    ),

    // ── Admin (nested sub-routes) ───────────────────────────────
    GoRoute(
      path: Routes.admin,
      builder: (_, __) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AdminCubit(sl<AdminService>())..loadDashboard(),
          ),
          BlocProvider(create: (_) => AuthCubit(sl<AuthService>())),
        ],
        child: const AdminDashboard(),
      ),
      routes: [
        GoRoute(
          path: 'classroom/:id',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            final allData = state.extra as AdminLoaded;
            return BlocProvider(
              create: (_) => AdminCubit(sl<AdminService>()),
              child: ClassroomDetailsPage(classroomId: id, allData: allData),
            );
          },
        ),
        GoRoute(
          path: 'subject/:id',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return BlocProvider(
              create: (_) => AdminCubit(sl<AdminService>()),
              child: SubjectDetailsPage(subjectId: id),
            );
          },
        ),
        GoRoute(
          path: 'schedule/:id',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return BlocProvider(
              create: (_) => AdminCubit(sl<AdminService>()),
              child: ScheduleDetailsPage(scheduleId: id),
            );
          },
        ),
        GoRoute(
          path: 'user/:id',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            final extra = state.extra as Map<String, dynamic>;
            return BlocProvider(
              create: (_) => AdminCubit(sl<AdminService>()),
              child: UserDetailsPage(
                userId: id,
                role: extra['role'] as String,
                isSuperAdmin: extra['isSuperAdmin'] as bool,
              ),
            );
          },
        ),
      ],
    ),

    // ── Student  ───────────────────────────────────────────
    GoRoute(
      path: Routes.student,
      builder: (_, __) => BlocProvider(
        create: (_) => StudentCubit(sl<StudentService>())..loadDashboard(),
        child: const StudentDashboard(),
      ),
    ),

    // ── Teacher ──────────────────────────────────────────────────
    GoRoute(path: Routes.teacher, builder: (_, __) => const TeacherDashboard()),

    // ── Parent ──────────────────────────────────────────────────
    GoRoute(path: Routes.parent, builder: (_, __) => const ParentDashboard()),

    // ── Super Admin (redirect to admin) ─────────────────────────
    GoRoute(path: Routes.superAdmin, redirect: (_, __) => Routes.admin),
  ],
);
