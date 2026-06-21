import 'package:flutter/material.dart';
import 'package:school_test/features/student/view/tabs/student_resources_tab.dart';
import 'package:school_test/features/student/view/tabs/student_subjects_tab.dart';
import 'package:school_test/features/student/view/tabs/student_teachers_tab.dart';
import 'package:school_test/features/student/view_model/cubit/student_cubit.dart';

class StudentMoreTab extends StatelessWidget {
  final StudentLoaded state;
  const StudentMoreTab({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(24),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          const Text(
            'More Options',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 16),
          _buildOptionCard(
            context,
            icon: Icons.subject,
            title: 'My Subjects',
            subtitle: 'View all enrolled subjects',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Scaffold(
                    appBar: AppBar(title: const Text('Subjects')),
                    body: CustomScrollView(
                      slivers: [StudentSubjectsTab(state: state)],
                    ),
                  ),
                ),
              );
            },
          ),
          _buildOptionCard(
            context,
            icon: Icons.person_outline,
            title: 'My Teachers',
            subtitle: 'View all teachers',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Scaffold(
                    appBar: AppBar(title: const Text('Teachers')),
                    body: CustomScrollView(
                      slivers: [StudentTeachersTab(state: state)],
                    ),
                  ),
                ),
              );
            },
          ),
          _buildOptionCard(
            context,
            icon: Icons.folder,
            title: 'Resources',
            subtitle: 'View learning resources',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Scaffold(
                    appBar: AppBar(title: const Text('Resources')),
                    body: CustomScrollView(
                      slivers: [StudentResourcesTab(state: state)],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 80),
        ]),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF2563EB), size: 28),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}