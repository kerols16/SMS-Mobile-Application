import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_test/features/admin/veiw_model/cubit/admin_cubit.dart';
import 'package:shimmer/shimmer.dart';

import '../../data/models/exam_model.dart';
import '../../data/models/subject_model.dart';
import '../../data/models/classroom_model.dart';
import '../utils/admin_helper.dart';
import '../sheets/create_exam_sheet.dart';
import '../sheets/edit_exam_sheet.dart';

class ExamsSection extends StatefulWidget {
  final AdminLoaded state;
  final bool isSuperAdmin;

  const ExamsSection({
    super.key,
    required this.state,
    required this.isSuperAdmin,
  });

  @override
  State<ExamsSection> createState() => _ExamsSectionState();
}

class _ExamsSectionState extends State<ExamsSection> {
  bool _isLoading = false;
  String? _error;

  // دالة تنسيق التاريخ
  String _formatDate(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) return 'N/A';
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return dateTimeString;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadExams();
    });
  }

  Future<void> _loadExams() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      await context.read<AdminCubit>().getExams();
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _showCreateExamSheet(BuildContext context, AdminLoaded state) {
    final cubit = context.read<AdminCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: CreateExamSheet(
          state: state,
          cubit: cubit,
          isSuperAdmin: widget.isSuperAdmin,
        ),
      ),
    );
  }

  void _showEditExamSheet(BuildContext context, AdminLoaded state, ExamModel exam) {
    final cubit = context.read<AdminCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: EditExamSheet(
          exam: exam,
          state: state,
          cubit: cubit,
          isSuperAdmin: widget.isSuperAdmin,
        ),
      ),
    );
  }

  void _confirmAndDelete(BuildContext context, ExamModel exam) {
    AdminHelper.confirmDelete(
      context,
      'Exam',
      () => context.read<AdminCubit>().deleteExam(exam.id),
    );
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

        final exams = state.exams;

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

              _buildExamStats(exams),

              const SizedBox(height: 20),

              if (exams.isEmpty)
                _buildEmptyState(context, state)
              else
                Column(
                  children: exams
                      .map((exam) => _buildExamTile(context, exam, state))
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
        const Text('Exams', style: AdminHelper.pageTitle),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _showCreateExamSheet(context, state),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add Exam'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 129, 2, 2),
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

  Widget _buildExamStats(List<ExamModel> exams) {
    return Row(
      children: [
        Expanded(
          child: _statCard('Total Exams', exams.length.toString(), Icons.assignment),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            'Avg Duration',
            exams.isEmpty
                ? '—'
                : '${(exams.map((e) => e.durationMinutes).reduce((a, b) => a + b) / exams.length).round()} min',
            Icons.timer,
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

  Widget _buildExamTile(BuildContext context, ExamModel exam, AdminLoaded state) {
    final classroom = state.classrooms.firstWhere(
      (c) => c.id == exam.classroomId,
      orElse: () => ClassroomModel(
        id: -1,
        name: 'Unknown',
        gradeLevel: '',
        capacity: 0,
        academicYear: '',
        description: null,
        isActive: false,
        students: [],
        teachers: [],
        subjects: [],
      ),
    );
    final subject = state.subjects.firstWhere(
      (s) => s.id == exam.subjectId,
      orElse: () => SubjectModel(
        id: -1,
        name: 'Unknown',
        code: '',
        description: null,
        credits: 0,
        type: '',
        isActive: false,
        classrooms: [],
        teachers: [],
      ),
    );

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
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.assignment, color: Colors.orange.shade700, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exam.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${classroom.name} • ${subject.name}',
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
                  onPressed: () => _showEditExamSheet(context, state, exam),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, size: 18, color: Colors.red.shade300),
                  onPressed: () => _confirmAndDelete(context, exam),
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
                if (exam.scheduledAt != null) ...[
                  const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      _formatDate(exam.scheduledAt), // ✅ تنسيق التاريخ
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                const Icon(Icons.timer_outlined, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${exam.durationMinutes} min',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.orange.withOpacity(0.4),
                      width: 0.8,
                    ),
                  ),
                  child: Text(
                    'Score: ${exam.maxScore}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange.shade700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),

            if (exam.instructions != null && exam.instructions!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.notes_outlined, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      exam.instructions!,
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
          Icon(Icons.assignment_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            'No exams created yet.',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          if (widget.isSuperAdmin) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _showCreateExamSheet(context, state),
              icon: const Icon(Icons.add),
              label: const Text('Add First Exam'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
          ],
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
            'Failed to load exams',
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
            onPressed: _loadExams,
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