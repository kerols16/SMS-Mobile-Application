import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_test/features/admin/veiw_model/cubit/admin_cubit.dart';
import 'package:shimmer/shimmer.dart';

import '../../data/models/grade_model.dart';
import '../../data/models/admin_student_model.dart';
import '../../data/models/exam_model.dart';
import '../utils/admin_helper.dart';
import '../sheets/create_grade_sheet.dart';
import '../sheets/edit_grade_sheet.dart';

class GradesSection extends StatefulWidget {
  final AdminLoaded state;
  final bool isSuperAdmin;

  const GradesSection({
    super.key,
    required this.state,
    required this.isSuperAdmin,
  });

  @override
  State<GradesSection> createState() => _GradesSectionState();
}

class _GradesSectionState extends State<GradesSection> {
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadGrades();
    });
  }

  Future<void> _loadGrades() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      await context.read<AdminCubit>().getGrades();
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _showCreateGradeSheet(BuildContext context, AdminLoaded state) {
    final cubit = context.read<AdminCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: CreateGradeSheet(
          state: state,
          cubit: cubit,
          isSuperAdmin: widget.isSuperAdmin,
        ),
      ),
    );
  }

  void _showEditGradeSheet(BuildContext context, AdminLoaded state, GradeModel grade) {
    final cubit = context.read<AdminCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: EditGradeSheet(
          grade: grade,
          state: state,
          cubit: cubit,
          isSuperAdmin: widget.isSuperAdmin,
        ),
      ),
    );
  }

  void _confirmAndDelete(BuildContext context, GradeModel grade) {
    AdminHelper.confirmDelete(
      context,
      'Grade',
      () => context.read<AdminCubit>().deleteGrade(grade.id),
    );
  }

  Color _getScoreColor(num score) {
    if (score >= 90) return Colors.green;
    if (score >= 70) return Colors.blue;
    if (score >= 50) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminCubit, AdminState>(
      builder: (context, state) {
        if (state is! AdminLoaded) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final grades = state.grades;

        if (_isLoading) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: _buildShimmer(),
            ),
          );
        }

        if (_error != null) {
          return SliverToBoxAdapter(child: _buildErrorState());
        }

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 16),

              _buildHeader(context, state),

              const SizedBox(height: 16),

              _buildGradeStats(grades),

              const SizedBox(height: 20),

              if (grades.isEmpty)
                _buildEmptyState(context, state)
              else
                Column(
                  children: grades
                      .map((grade) => _buildGradeTile(context, grade, state))
                      .toList(),
                ),

              const SizedBox(height: 100),
            ]),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, AdminLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Grades', style: AdminHelper.pageTitle),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _showCreateGradeSheet(context, state),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add Grade'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGradeStats(List<GradeModel> grades) {
    final nonNullScores = grades.where((g) => g.score != null).map((g) => g.score!);
    final average = nonNullScores.isEmpty
        ? 0.0
        : nonNullScores.reduce((a, b) => a + b) / nonNullScores.length;

    return Row(
      children: [
        Expanded(
          child: _statCard(
            'Total Grades',
            grades.length.toString(),
            Icons.grade,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            'Avg Score',
            nonNullScores.isEmpty ? '—' : average.toStringAsFixed(1),
            Icons.assessment,
          ),
        ),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade700),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGradeTile(BuildContext context, GradeModel grade, AdminLoaded state) {
    final studentName = grade.student?.user?.name ??
        state.students.firstWhere(
          (s) => s.id == grade.studentId,
          orElse: () => AdminStudentModel(
            id: grade.studentId,
            userId: 0,
            studentId: 'Unknown',
            gender: '',
            address: '',
            phone: '',
            enrollmentDate: '',
            dateOfBirth: '',
            name: 'Unknown Student',
            email: '',
          ),
        ).name;

    final examName = grade.exam?.name ??
        state.exams.firstWhere(
          (e) => e.id == grade.examId,
          orElse: () => ExamModel(
            id: -1,
            subjectId: -1,
            classroomId: -1,
            name: 'Unknown Exam',
            type: '',
            maxScore: 0,
            scheduledAt: null,
            durationMinutes: 0,
            isOnline: false,
            instructions: null,
            createdAt: null,
            updatedAt: null,
          ),
        ).name;

    final score = grade.score ?? 0;
    final scoreColor = _getScoreColor(score);

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: scoreColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.grade, color: scoreColor, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        studentName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        examName,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit_outlined, size: 18, color: Colors.blue.shade700),
                  onPressed: () => _showEditGradeSheet(context, state, grade),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, size: 18, color: Colors.red.shade300),
                  onPressed: () => _confirmAndDelete(context, grade),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ],
            ),

            const SizedBox(height: 8),
            const Divider(height: 1, thickness: 0.5),
            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(Icons.score_outlined, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Score: $score',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
                if (grade.gradeLetter != null) ...[
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: scoreColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      grade.gradeLetter!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: scoreColor,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: scoreColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: scoreColor.withOpacity(0.4),
                      width: 0.8,
                    ),
                  ),
                  child: Text(
                    score >= 90
                        ? 'EXCELLENT'
                        : score >= 70
                            ? 'GOOD'
                            : score >= 50
                                ? 'AVERAGE'
                                : 'FAILING',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: scoreColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),

            if (grade.remarks != null && grade.remarks!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.notes_outlined, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      grade.remarks!,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AdminLoaded state) {
    return Center(
      child: Column(
        children: [
          Icon(Icons.grade_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            'No grades recorded yet.',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _showCreateGradeSheet(context, state),
            icon: const Icon(Icons.add),
            label: const Text('Add First Grade'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
          const SizedBox(height: 12),
          Text(
            'Failed to load grades',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 8),
          Text(
            _error ?? 'Unknown error',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadGrades,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: List.generate(
          5,
          (_) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}