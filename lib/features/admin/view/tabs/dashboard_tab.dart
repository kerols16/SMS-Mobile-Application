import 'package:flutter/material.dart';
import '../../veiw_model/cubit/admin_cubit.dart';
import '../utils/admin_helper.dart';
import '../sheets/create_student_sheet.dart';
import '../sheets/create_teacher_sheet.dart';
import '../sheets/create_user_sheet.dart';
import '../sheets/create_parent_sheet.dart';

class DashboardTab extends StatelessWidget {
  final AdminLoaded state;
  final bool isSuperAdmin;

  const DashboardTab({
    super.key,
    required this.state,
    required this.isSuperAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16,
            shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            children: [
              AdminHelper.buildStatCard(icon: Icons.school,               color: Colors.blue,   value: state.students.length.toString(), label: 'Total Students'),
              AdminHelper.buildStatCard(icon: Icons.menu_book,            color: Colors.teal,   value: state.teachers.length.toString(), label: 'Total Teachers'),
              AdminHelper.buildStatCard(icon: Icons.manage_accounts,      color: Colors.purple, value: state.users.length.toString(),    label: 'Total Users'),
              AdminHelper.buildStatCard(icon: Icons.notifications_active, color: Colors.orange, value: state.unreadCount.toString(),     label: 'Unread Notifications'),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Quick Actions', style: AdminHelper.sectionTitle),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12,
            shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            children: [
              AdminHelper.buildActionButton(icon: Icons.person_add,    label: 'Add Student', color: Colors.blue,   onTap: () => showCreateStudentSheet(context)),
              AdminHelper.buildActionButton(icon: Icons.menu_book,     label: 'Add Teacher', color: Colors.teal,   onTap: () => showCreateTeacherSheet(context)),
              AdminHelper.buildActionButton(icon: Icons.group_add,     label: 'Add User',    color: Colors.purple, onTap: () => showCreateUserSheet(context, isSuperAdmin)),
              AdminHelper.buildActionButton(icon: Icons.family_restroom, label: 'Add Parent',  color: Colors.orange, onTap: () => showCreateParentSheet(context)),
            ],
          ),
          const SizedBox(height: 100),
        ]),
      ),
    );
  }
}
