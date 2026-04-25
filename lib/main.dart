import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:school_test/view/screens/admin_dashboard.dart';
import 'package:school_test/view/screens/login_screen.dart';
import 'package:school_test/view/screens/parent_dashboard.dart';
import 'package:school_test/view/screens/student_dashboard.dart';
import 'package:school_test/view/screens/teacher_dashboard.dart';


void main() async{
  runApp(const MyApp());
  await InitDependency ;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/admin': (context) => const AdminDashboard(),
        '/teacher': (context) => const TeacherDashboard(),
        '/student': (context) => const StudentDashboard(),
        '/parent': (context) => const ParentDashboard(),
      },
    );
  }
}