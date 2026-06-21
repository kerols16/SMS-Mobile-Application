import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:school_test/core/constants/routes_contents.dart';
import 'package:school_test/core/storage/local_srotage.dart';
import 'package:school_test/features/admin/view/academics_sections/overview_section.dart';
import 'package:school_test/features/admin/view/tabs/academics_tab.dart';
import 'package:school_test/features/admin/view/tabs/notifications_tab.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/widgets/bottom_nav.dart';
import '../../veiw_model/cubit/admin_cubit.dart';
import '../tabs/dashboard_tab.dart';
import '../tabs/users_tab.dart';
import '../tabs/profile_tab.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  String _activeTab = 'dashboard';
  String _originalRole = 'admin';

  bool get _isSuperAdmin => _originalRole == 'super_admin';

  @override
  void initState() {
    super.initState();
    _loadOriginalRole();
    context.read<AdminCubit>().loadDashboard();
  }

  Future<void> _loadOriginalRole() async {
    final role = await LocalStorage.getOriginalRole();
    if (role != null) setState(() => _originalRole = role);
  }

  final List<NavItem> _navItems = [
    NavItem(id: 'dashboard', label: 'Dashboard', icon: Icons.home),
    NavItem(id: 'academics', label: 'Academics', icon: Icons.school),
    NavItem(id: 'notifications', label: 'Notifs', icon: Icons.notifications),
    NavItem(id: 'users', label: 'Users', icon: Icons.manage_accounts),
    NavItem(id: 'profile', label: 'Profile', icon: Icons.person),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminCubit, AdminState>(
      listener: (context, state) {
        if (state is AdminOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        }
        if (state is AdminOperationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        body: BlocBuilder<AdminCubit, AdminState>(
          builder: (context, state) {
            return Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    _buildHeader(state),
                    if (state is AdminLoading)
                      SliverPadding(
                        padding: const EdgeInsets.all(24),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            const SizedBox(height: 16),
                            _buildShimmerGrid(),
                            const SizedBox(height: 24),
                            _buildShimmerList(),
                          ]),
                        ),
                      )
                    else if (state is AdminError)
                      SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 48,
                                color: Colors.red.shade300,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                state.message,
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  context.read<AdminCubit>().loadDashboard();
                                },
                                child: const Text('Try Again'),
                              ),
                            ],
                          ),
                        ),
                      )
                    else if (state is AdminLoaded) ...[
                      if (_activeTab == 'dashboard')
                        DashboardTab(state: state, isSuperAdmin: _isSuperAdmin),
                      if (_activeTab == 'academics')
                        AcademicsTab(state: state, isSuperAdmin: _isSuperAdmin),
                      if (_activeTab == 'notifications')
                        NotificationsTab(
                          state: state,
                          isSuperAdmin: _isSuperAdmin,
                        ),
                      if (_activeTab == 'users')
                        UsersTab(state: state, isSuperAdmin: _isSuperAdmin),
                      if (_activeTab == 'profile')
                        ProfileTab(
                          isSuperAdmin: _isSuperAdmin,
                          onLogout: () async {
                            await LocalStorage.clear();
                            if (context.mounted) context.go(Routes.login);
                          },
                        ),
                    ],
                  ],
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
            );
          },
        ),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
          4,
          (_) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: List.generate(
          5,
          (_) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildHeader(AdminState state) {
    final unread = state is AdminLoaded ? state.unreadCount : 0;
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isSuperAdmin
                ? [const Color(0xFFDC2626), const Color(0xFF991B1B)]
                : [const Color(0xFF2563EB), const Color(0xFF1E40AF)],
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
                  'Good Morning',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _isSuperAdmin ? 'Super Admin Dashboard' : 'Admin Dashboard',
                  style: const TextStyle(
                    color: Color(0xFFBFDBFE),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () => setState(() => _activeTab = 'notifications'),
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
                  if (unread > 0)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
