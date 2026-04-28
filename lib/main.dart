import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:school_test/core/router/app_router.dart';
import 'package:school_test/features/admin/view/admin_dashboard.dart';
import 'package:school_test/features/auth/view/login_screen.dart';
import 'package:school_test/features/parent/view/parent_dashboard.dart';
import 'package:school_test/features/student/view/student_dashboard.dart';
import 'package:school_test/features/teacher/view/teacher_dashboard.dart';


void main() async{
  runApp(const MyApp());
  await InitDependency ;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'EduManage UI Demo',
      debugShowCheckedModeBanner: false,
    
      theme: ThemeData(
        primaryColor: const Color(0xFF2563EB),
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
        fontFamily: 'Poppins',
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFF374151),
        ),
      ),
      routerConfig: router,
      
    );
  }
}