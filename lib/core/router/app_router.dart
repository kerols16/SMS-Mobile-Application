import 'package:go_router/go_router.dart';
import 'package:school_test/core/constents/routes_contents.dart';
import 'package:school_test/features/admin/view/admin_dashboard.dart';
import 'package:school_test/features/auth/view/login_screen.dart';
import 'package:school_test/features/parent/view/parent_dashboard.dart';
import 'package:school_test/features/student/view/student_dashboard.dart';
import 'package:school_test/features/teacher/view/teacher_dashboard.dart';

final GoRouter router = GoRouter(
  initialLocation: Routes.login,
  routes: [
    GoRoute(
      path: Routes.login,
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: Routes.admin,
      builder: (context, state) => AdminDashboard(),
    ),
    GoRoute(
      path: Routes.teacher,
      builder: (context, state) => TeacherDashboard(),
    ),
     GoRoute(
      path: Routes.parent,
      builder: (context, state) => ParentDashboard(),
    ),
     GoRoute(
      path: Routes.student,
      builder: (context, state) => StudentDashboard(),
    ),
  ],
);