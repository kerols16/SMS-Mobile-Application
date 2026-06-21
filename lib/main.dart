import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_test/core/di/injection_container.dart';
import 'package:school_test/core/router/app_router.dart';
import 'package:school_test/core/storage/local_srotage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached || state == AppLifecycleState.paused) {
      _performLogout();
    }
  }

  Future<void> _performLogout() async {
    try {
      await LocalStorage.clearAll();
      
      await Future.delayed(const Duration(milliseconds: 200));
      
      if (routerNavigatorKey.currentContext != null) {
        routerNavigatorKey.currentContext!.go('/splash');
      }
    } catch (e) {
    }
  }

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