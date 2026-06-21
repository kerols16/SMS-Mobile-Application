import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_test/features/admin/veiw_model/cubit/admin_cubit.dart';
import 'package:school_test/features/admin/data/models/attendance_model.dart';
import 'package:school_test/features/admin/data/models/admin_student_model.dart';
import 'package:school_test/features/admin/data/models/classroom_model.dart';
import 'package:shimmer/shimmer.dart';
import '../utils/admin_helper.dart';
import '../sheets/create_attendance_sheet.dart';
import '../sheets/edit_attendance_sheet.dart';

class AttendanceSection extends StatefulWidget {
  final AdminLoaded state;
  final bool isSuperAdmin;

  const AttendanceSection({
    super.key,
    required this.state,
    required this.isSuperAdmin,
  });

  @override
  State<AttendanceSection> createState() => _AttendanceSectionState();
}

class _AttendanceSectionState extends State<AttendanceSection> {
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadAttendances();
    });
  }

  Future<void> _loadAttendances() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      await context.read<AdminCubit>().getAttendances();
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

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
  Widget build(BuildContext context) {
    return BlocBuilder<AdminCubit, AdminState>(
      builder: (context, blocState) {
        if (blocState is! AdminLoaded) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final attendances = blocState.attendances;

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 16),

              _buildHeader(context, blocState),

              const SizedBox(height: 16),

              if (_error == null && !_isLoading)
                _buildAttendanceStats(attendances),

              const SizedBox(height: 20),

              if (_error != null)
                _buildErrorState()
              else if (_isLoading)
                _buildShimmerList()
              else if (attendances.isEmpty)
                _buildEmptyState(context, blocState)
              else
                Column(
                  children: attendances
                      .map((att) => _buildAttendanceTile(context, att, blocState))
                      .toList(),
                ),

              const SizedBox(height: 100),
            ]),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, AdminLoaded blocState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Attendance Records', style: AdminHelper.pageTitle),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _showCreateAttendanceSheet(context, blocState),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add Attendance'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
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

  Widget _buildAttendanceStats(List<AttendanceModel> attendances) {
    final present = attendances.where((a) => a.status == 'present').length;
    final absent = attendances.where((a) => a.status == 'absent').length;
    final late = attendances.where((a) => a.status == 'late').length;

    return Row(
      children: [
        Expanded(
          child: AdminHelper.buildStatCard(
            icon: Icons.check_circle,
            color: Colors.green,
            value: present.toString(),
            label: 'Present',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: AdminHelper.buildStatCard(
            icon: Icons.cancel,
            color: Colors.red,
            value: absent.toString(),
            label: 'Absent',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: AdminHelper.buildStatCard(
            icon: Icons.warning,
            color: Colors.orange,
            value: late.toString(),
            label: 'Late',
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceTile(BuildContext context, AttendanceModel att, AdminLoaded state) {
    final student = state.students.firstWhere(
      (s) => s.id == att.studentId,
      orElse: () => AdminStudentModel(
        id: att.studentId,
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
    );
    final classroom = state.classrooms.firstWhere(
      (c) => c.id == att.classroomId,
      orElse: () => ClassroomModel(
        id: att.classroomId,
        name: 'Unknown Classroom',
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

    final statusConfig = _getStatusConfig(att.status);

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
                    color: statusConfig.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(statusConfig.icon, color: statusConfig.color, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        classroom.name,
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
                  icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.grey),
                  onPressed: () => _showEditAttendanceSheet(context, att, state),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, size: 18, color: Colors.red.shade300),
                  onPressed: () => AdminHelper.confirmDelete(
                    context,
                    'attendance record',
                    () => context.read<AdminCubit>().deleteAttendance(att.id),
                  ),
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
                const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  _formatDate(att.date), // ✅ تنسيق التاريخ
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusConfig.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: statusConfig.color.withOpacity(0.4),
                      width: 0.8,
                    ),
                  ),
                  child: Text(
                    att.status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: statusConfig.color,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),

            // ✅ Notes لو موجودة
            if (att.notes != null && att.notes!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.notes_outlined, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      att.notes!,
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

  // ✅ Helper للحالة بدل switch متكرر
  ({Color color, IconData icon}) _getStatusConfig(String status) {
    return switch (status) {
      'present' => (color: Colors.green, icon: Icons.check_circle),
      'absent'  => (color: Colors.red,   icon: Icons.cancel),
      'late'    => (color: Colors.orange, icon: Icons.warning),
      _         => (color: Colors.grey,   icon: Icons.help),
    };
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

  Widget _buildEmptyState(BuildContext context, AdminLoaded state) {
    return Center(
      child: Column(
        children: [
          const Icon(Icons.event_busy, size: 48, color: Colors.grey),
          const SizedBox(height: 12),
          const Text('No attendance records found.'),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _showCreateAttendanceSheet(context, state),
            child: const Text('Add First Record'),
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
            'Failed to load attendances',
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
            onPressed: _loadAttendances,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showCreateAttendanceSheet(BuildContext context, AdminLoaded state) {
    final cubit = context.read<AdminCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: CreateAttendanceSheet(
          state: state,
          isSuperAdmin: widget.isSuperAdmin,
          cubit: cubit,
        ),
      ),
    );
  }

  void _showEditAttendanceSheet(BuildContext context, AttendanceModel att, AdminLoaded state) {
    final cubit = context.read<AdminCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: EditAttendanceSheet(
          attendance: att,
          state: state,
          isSuperAdmin: widget.isSuperAdmin,
          cubit: cubit,
        ),
      ),
    );
  }
}