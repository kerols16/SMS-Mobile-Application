import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:school_test/core/constants/routes_contents.dart';
import 'package:school_test/core/di/injection_container.dart';
import 'package:school_test/core/storage/local_srotage.dart';
import 'package:school_test/core/widgets/bottom_nav.dart';
import 'package:school_test/features/teacher/view/tabs/classes_tab.dart';
import 'package:school_test/features/teacher/view/tabs/exams_tab.dart';
import 'package:school_test/features/teacher/view/tabs/home_tab.dart';
import 'package:school_test/features/teacher/view/tabs/messages_tab.dart';
import 'package:school_test/features/teacher/view/tabs/more_tab.dart';
import 'package:school_test/features/teacher/view_model/cubit/teacher_cubit.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  int _selectedIndex = 0;
  int _teacherId = 0;
  String _teacherName = '';
  bool _isLoading = true;

  final List<NavItem> _navItems = [
    NavItem(id: 'home', label: 'Home', icon: Icons.home),
    NavItem(id: 'classes', label: 'Classes', icon: Icons.school),
    NavItem(id: 'messages', label: 'Messages', icon: Icons.message),
    NavItem(id: 'exams', label: 'Exams', icon: Icons.quiz),
    NavItem(id: 'more', label: 'More', icon: Icons.more_horiz),
  ];

  @override
  void initState() {
    super.initState();
    _loadTeacherData();
  }

  Future<void> _loadTeacherData() async {
    final teacherIdStr = await LocalStorage.getTeacherId();
    final name = await LocalStorage.getUserName();
    setState(() {
      _teacherId = int.tryParse(teacherIdStr ?? '0') ?? 0;
      _teacherName = name ?? 'Teacher';
      _isLoading = false;
    });
  }

  void _onTabChange(String tabId) {
    setState(() {
      switch (tabId) {
        case 'home':
          _selectedIndex = 0;
          break;
        case 'classes':
          _selectedIndex = 1;
          break;
        case 'messages':
          _selectedIndex = 2;
          break;
        case 'exams':
          _selectedIndex = 3;
          break;
        case 'more':
          _selectedIndex = 4;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return BlocProvider(
      create: (_) => sl<TeacherCubit>()..loadDashboard(_teacherId),
      child: BlocListener<TeacherCubit, TeacherState>(
        listener: (context, state) {
          if (state is TeacherOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is TeacherOperationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is TeacherError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Builder(
          builder: (context) {
            final cubit = context.read<TeacherCubit>();
            return Scaffold(
              body: Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: () => cubit.refreshDashboard(),
                    child: CustomScrollView(
                      slivers: [
                        // Header
                        SliverToBoxAdapter(
                          child: Container(
                            color: const Color(0xFF2563EB),
                            padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Good Morning',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _teacherName,
                                      style: const TextStyle(
                                        color: Color(0xFFBFDBFE),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                // إشعارات
                                BlocBuilder<TeacherCubit, TeacherState>(
                                  builder: (context, state) {
                                    int unreadCount = 0;
                                    if (state is TeacherLoaded) {
                                      unreadCount = state.unreadMessageCount;
                                    }
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedIndex = 2; // messages tab
                                        });
                                      },
                                      child: Stack(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: const Icon(
                                              Icons.notifications,
                                              color: Colors.white,
                                              size: 24,
                                            ),
                                          ),
                                          if (unreadCount > 0)
                                            Positioned(
                                              top: 4,
                                              right: 4,
                                              child: Container(
                                                width: 10,
                                                height: 10,
                                                decoration: const BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        // المحتوى حسب التبويب المختار
                        BlocBuilder<TeacherCubit, TeacherState>(
                          builder: (context, state) {
                            if (state is TeacherLoading) {
                              return const SliverFillRemaining(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            } else if (state is TeacherError) {
                              return SliverFillRemaining(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.error_outline,
                                        size: 48,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(state.message),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: () =>
                                            cubit.refreshDashboard(),
                                        child: const Text('Retry'),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else if (state is TeacherLoaded) {
                              switch (_selectedIndex) {
                                case 0:
                                  return HomeTab(state: state);
                                case 1:
                                  return ClassesTab(state: state);
                                case 2:
                                  return MessagesTab(
                                    state: state,
                                    cubit: cubit,
                                  );
                                case 3:
                                  return ExamsTab(
                                    state: state,
                                    cubit: cubit,
                                  );
                                case 4:
                                  return MoreTab(
                                    state: state,
                                    cubit: cubit,
                                    onLogout: () async {
                                      await LocalStorage.clear();
                                      if (context.mounted) {
                                        context.go(Routes.login);
                                      }
                                    },
                                  );
                                default:
                                  return const SliverToBoxAdapter(
                                    child: SizedBox(),
                                  );
                              }
                            }
                            return const SliverToBoxAdapter(child: SizedBox());
                          },
                        ),
                      ],
                    ),
                  ),

                  // Bottom Navigation
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: BottomNav(
                      items: _navItems,
                      activeTab: _navItems[_selectedIndex].id,
                      onTabChange: _onTabChange,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}