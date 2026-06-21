import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:school_test/core/constants/routes_contents.dart';
import 'package:school_test/core/storage/local_srotage.dart';
import 'package:school_test/core/widgets/bottom_nav.dart';
import 'package:school_test/features/student/view/tabs/student_assignments_tab.dart';
import 'package:school_test/features/student/view/tabs/student_grades_tab.dart';
import 'package:school_test/features/student/view/tabs/student_home_tab.dart';
import 'package:school_test/features/student/view/tabs/student_more_tab.dart';
import 'package:school_test/features/student/view/tabs/student_profile_tab.dart';
import 'package:school_test/features/student/view/tabs/student_schedule_tab.dart';
import 'package:school_test/features/student/view_model/cubit/student_cubit.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  String _activeTab = 'home';

  // نضيف تبويب "more" قبل "profile"
  final List<NavItem> _navItems = [
    NavItem(id: 'home', label: 'Home', icon: Icons.home),
    NavItem(id: 'schedule', label: 'Schedule', icon: Icons.calendar_today),
    NavItem(id: 'assignments', label: 'Assignments', icon: Icons.assignment),
    NavItem(id: 'grades', label: 'Grades', icon: Icons.grade),
    NavItem(id: 'more', label: 'More', icon: Icons.more_horiz),   // الجديد
    NavItem(id: 'profile', label: 'Profile', icon: Icons.person), // موجود سابقاً
  ];

  @override
  void initState() {
    super.initState();
    context.read<StudentCubit>().loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StudentCubit, StudentState>(
      listener: (context, state) {
        if (state is StudentOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is StudentOperationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            BlocBuilder<StudentCubit, StudentState>(
              builder: (context, state) {
                return CustomScrollView(
                  slivers: [
                    _buildHeader(state),
                    if (state is StudentLoading)
                      const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (state is StudentError)
                      SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                state.message,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.red),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () =>
                                    context.read<StudentCubit>().loadDashboard(),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      )
                    else if (state is StudentLoaded) ...[
                      if (_activeTab == 'home')
                        StudentHomeTab(state: state)
                      else if (_activeTab == 'schedule')
                        StudentScheduleTab(state: state)
                      else if (_activeTab == 'assignments')
                        StudentAssignmentsTab(state: state)
                      else if (_activeTab == 'grades')
                        StudentGradesTab(state: state)
                      else if (_activeTab == 'more')
                        StudentMoreTab(state: state) // التبويب الجديد
                      else if (_activeTab == 'profile')
                        StudentProfileTab(
                          state: state,
                          onLogout: () async {
                            await LocalStorage.clear();
                            if (context.mounted) context.go(Routes.login);
                          },
                        ),
                    ],
                  ],
                );
              },
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: BottomNav(
                items: _navItems,
                activeTab: _activeTab,
                onTabChange: (tab) => setState(() => _activeTab = tab),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(StudentState state) {
    final name = state is StudentLoaded ? state.profile.name : 'Loading...';

    return SliverToBoxAdapter(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
          ),
        ),
        padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome Back',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: const TextStyle(
                    color: Color(0xFFBFDBFE),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}