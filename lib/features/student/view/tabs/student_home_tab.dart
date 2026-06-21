import 'package:flutter/material.dart';
import 'package:school_test/features/student/view/cards/next_class_card.dart';
import 'package:school_test/features/student/view/cards/pending_assignments_card.dart';
import 'package:school_test/features/student/view/cards/recent_grades_card.dart';
import 'package:school_test/features/student/view/items/stat_cards_row.dart';
import 'package:school_test/features/student/view_model/cubit/student_cubit.dart';

class StudentHomeTab extends StatelessWidget {
  final StudentLoaded state;
  const StudentHomeTab({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final nextClass = state.schedule.isNotEmpty ? state.schedule.first : null;

    final pendingAssignments = state.assignments
        .where((a) => !a.submitted)
        .take(3)
        .toList();

    final recentGrades = state.grades.take(3).toList();

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          const SizedBox(height: 16),
          NextClassCard(schedule: nextClass),
          const SizedBox(height: 24),
          StatCardsRow(
            dashboard: state.dashboard,
            attendanceSummary: state.attendanceSummary,
          ),
          const SizedBox(height: 24),
          PendingAssignmentsCard(assignments: pendingAssignments),
          const SizedBox(height: 24),
          RecentGradesCard(grades: recentGrades),
          const SizedBox(height: 24),
          const SizedBox(height: 100),
        ]),
      ),
    );
  }
}