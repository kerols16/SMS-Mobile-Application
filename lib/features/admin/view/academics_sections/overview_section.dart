import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:school_test/core/constants/routes_contents.dart';
import 'package:school_test/features/admin/data/models/classroom_model.dart';
import 'package:school_test/features/admin/data/models/subject_model.dart';
import 'package:school_test/features/admin/veiw_model/cubit/admin_cubit.dart';
import 'package:school_test/features/admin/view/pages/classrooms_form_page.dart';
import 'package:school_test/features/admin/view/sheets/schedule_form_page.dart';
import 'package:school_test/features/admin/view/sheets/subject_form_page.dart';
import '../utils/admin_helper.dart';

class OverviewSection extends StatelessWidget {
  final AdminLoaded state;
  final bool isSuperAdmin;

  const OverviewSection({
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

          // Stats
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              AdminHelper.buildStatCard(
                icon: Icons.class_,
                color: Colors.teal,
                value: state.classrooms.length.toString(),
                label: 'Total Classrooms',
              ),
              AdminHelper.buildStatCard(
                icon: Icons.menu_book,
                color: Colors.purple,
                value: state.subjects.length.toString(),
                label: 'Total Subjects',
              ),
              AdminHelper.buildStatCard(
                icon: Icons.schedule,
                color: Colors.orange,
                value: state.schedules.length.toString(),
                label: 'Schedules',
              ),
              AdminHelper.buildStatCard(
                icon: Icons.assessment,
                color: Colors.blue,
                value: '${state.students.length}',
                label: 'Enrolled Students',
              ),
            ],
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: AdminHelper.buildActionButton(
                  icon: Icons.add,
                  label: 'Add Classroom',
                  color: Colors.teal,
                  onTap: () => _navigateToClassroomForm(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AdminHelper.buildActionButton(
                  icon: Icons.add,
                  label: 'Add Subject',
                  color: Colors.purple,
                  onTap: () => _navigateToSubjectForm(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AdminHelper.buildActionButton(
                  icon: Icons.add,
                  label: 'Add Schedule',
                  color: Colors.orange,
                  onTap: () => _navigateToScheduleForm(context),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Classrooms
          const Text('Classrooms', style: AdminHelper.sectionTitle),
          const SizedBox(height: 12),
          ...state.classrooms.map((c) => _buildClassroomTile(context, c)),

          const SizedBox(height: 24),

          // Subjects
          const Text('Subjects', style: AdminHelper.sectionTitle),
          const SizedBox(height: 12),
          ...state.subjects.map((s) => _buildSubjectTile(context, s)),

          const SizedBox(height: 24),

          // Schedules
          const Text('Schedules', style: AdminHelper.sectionTitle),
          const SizedBox(height: 12),
          if (state.schedules.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  'No schedules found',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            ...state.schedules.map((s) => _buildScheduleTile(context, s)),

          const SizedBox(height: 100),
        ]),
      ),
    );
  }

  Widget _buildClassroomTile(BuildContext context, ClassroomModel classroom) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.teal.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.class_, color: Colors.teal),
        ),
        title: Text(classroom.name),
        subtitle: Text(
          'Grade ${classroom.gradeLevel} • Capacity: ${classroom.capacity}',
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        // ✅ go_router بدل Navigator.push — مفيش .then() ولا loadDashboard() زيادة
        onTap: () => context.go(
          '${Routes.admin}/${Routes.adminClassroom(classroom.id)}',
          extra: state,
        ),
      ),
    );
  }

  Widget _buildSubjectTile(BuildContext context, SubjectModel subject) {
    return Card(
      color: Colors.white,

      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.purple.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.menu_book, color: Colors.purple),
        ),
        title: Text(subject.name),
        subtitle: Text('Code: ${subject.code} • Credits: ${subject.credits}'),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        // ✅ go_router
        onTap: () =>
            context.go('${Routes.admin}/${Routes.adminSubject(subject.id)}'),
      ),
    );
  }

  Widget _buildScheduleTile(BuildContext context, dynamic schedule) {
    final classroomName = schedule.classroom?['name'] ?? 'N/A';
    final subjectName = schedule.subject?['name'] ?? 'N/A';
    return Card(
      color: Colors.white,

      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.orange.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.schedule, color: Colors.orange),
        ),
        title: Text('$classroomName - $subjectName'),
        subtitle: Text(
          '${schedule.dayOfWeek.toUpperCase()} ${schedule.startTime}-${schedule.endTime}',
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        // ✅ go_router
        onTap: () =>
            context.go('${Routes.admin}/${Routes.adminSchedule(schedule.id)}'),
      ),
    );
  }

  // ── Form pages: لسه بـ Navigator.push لأنها مش sub-routes ──────
  void _navigateToClassroomForm(BuildContext context) {
    final cubit = context.read<AdminCubit>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            BlocProvider.value(value: cubit, child: const ClassroomFormPage()),
      ),
    ).then((_) => cubit.loadDashboard());
  }

  void _navigateToSubjectForm(BuildContext context) {
    final cubit = context.read<AdminCubit>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            BlocProvider.value(value: cubit, child: const SubjectFormPage()),
      ),
    ).then((_) => cubit.loadDashboard());
  }

  void _navigateToScheduleForm(BuildContext context) {
    final cubit = context.read<AdminCubit>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            BlocProvider.value(value: cubit, child: const ScheduleFormPage()),
      ),
    ).then((_) => cubit.loadDashboard());
  }
}
