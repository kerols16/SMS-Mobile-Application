import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_test/core/constants/routes_contents.dart';
import 'package:school_test/core/storage/local_srotage.dart';
import 'package:school_test/features/teacher/data/models/teacher_attendance_model.dart';
import 'package:school_test/features/teacher/view_model/cubit/teacher_cubit.dart';

class MoreTab extends StatefulWidget {
  final TeacherLoaded state;
  final TeacherCubit cubit;
  final VoidCallback onLogout;
  const MoreTab({super.key, required this.state, required this.cubit, required this.onLogout});

  @override
  State<MoreTab> createState() => _MoreTabState();
}

class _MoreTabState extends State<MoreTab> {
  String _section = 'menu'; // menu | attendance | grades | resources

  @override
  Widget build(BuildContext context) {
    if (_section == 'attendance') return _attendanceSection();
    if (_section == 'grades') return _gradesSection();
    if (_section == 'resources') return _resourcesSection();
    return _menuSection();
  }

  Widget _menuSection() {
    return SliverPadding(
      padding: const EdgeInsets.all(24),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          // Profile Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: _cardDecoration(),
            child: Column(
              children: [
                Container(
                  width: 80, height: 80,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)]),
                  ),
                  child: Center(
                    child: Text(
                      widget.state.teacherName.isNotEmpty ? widget.state.teacherName[0].toUpperCase() : 'T',
                      style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(widget.state.teacherName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(20)),
                  child: Text(widget.state.teacherRole.toUpperCase(), style: const TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w600, fontSize: 13)),
                ),
                const SizedBox(height: 12),
                Text('ID: ${widget.state.teacherUserId}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Menu Items
          Container(
            decoration: _cardDecoration(),
            child: Column(
              children: [
                _menuItem(Icons.fact_check, 'Attendance', Colors.green, () => setState(() => _section = 'attendance')),
                _menuItem(Icons.grade, 'Grades', Colors.blue, () => setState(() => _section = 'grades')),
                _menuItem(Icons.folder, 'Resources', Colors.teal, () => setState(() => _section = 'resources')),
              ],
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity, height: 56,
            child: ElevatedButton.icon(
              onPressed: widget.onLogout,
              icon: const Icon(Icons.logout, size: 20),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFEF2F2),
                foregroundColor: const Color(0xFFDC2626),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 80),
        ]),
      ),
    );
  }

  Widget _menuItem(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade100))),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF374151)))),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // ── ATTENDANCE ─────────────────────────────────────
  Widget _attendanceSection() {
    return SliverPadding(
      padding: const EdgeInsets.all(24),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _section = 'menu'),
                child: const Icon(Icons.arrow_back, color: Color(0xFF374151)),
              ),
              const SizedBox(width: 12),
              const Text('Attendance', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _showRecordAttendanceDialog(),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Record'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (widget.state.attendances.isEmpty)
            const Center(child: Padding(
              padding: EdgeInsets.all(48),
              child: Text('No attendance records', style: TextStyle(color: Colors.grey)),
            ))
          else
            ...widget.state.attendances.map((a) => _attendanceCard(a)),
          const SizedBox(height: 80),
        ]),
      ),
    );
  }

  Widget _attendanceCard(TeacherAttendanceModel a) {
    final statusColor = {
      'present': Colors.green,
      'absent': Colors.red,
      'late': Colors.orange,
      'excused': Colors.blue,
    }[a.status] ?? Colors.grey;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.person, color: statusColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(a.studentName ?? 'Student #${a.studentId}',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF374151))),
                const SizedBox(height: 2),
                Text('${a.date} · ${a.classroomName ?? 'Classroom #${a.classroomId}'}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                if (a.notes != null && a.notes!.isNotEmpty)
                  Text(a.notes!, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
            child: Text(a.status.toUpperCase(), style: TextStyle(fontSize: 11, color: statusColor, fontWeight: FontWeight.w600)),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, size: 18, color: Colors.grey),
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
            ],
            onSelected: (val) {
              if (val == 'edit') _showEditAttendanceDialog(a);
              if (val == 'delete') widget.cubit.deleteAttendance(a.id);
            },
          ),
        ],
      ),
    );
  }

  void _showRecordAttendanceDialog() {
    String? selectedStudentId;
    String? selectedClassroomId;
    String selectedStatus = 'present';
    final notesController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => StatefulBuilder(
        builder: (context, setStateSheet) => SingleChildScrollView(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(child: Text('Record Attendance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600))),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Classroom *', border: OutlineInputBorder()),
                items: widget.state.classrooms.map((c) =>
                  DropdownMenuItem(value: c.id.toString(), child: Text(c.name))).toList(),
                onChanged: (val) => setStateSheet(() => selectedClassroomId = val),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Student *', border: OutlineInputBorder()),
                items: widget.state.students.map((s) =>
                  DropdownMenuItem(value: s.id.toString(), child: Text(s.name))).toList(),
                onChanged: (val) => setStateSheet(() => selectedStudentId = val),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
                items: ['present', 'absent', 'late', 'excused'].map((s) =>
                  DropdownMenuItem(value: s, child: Text(s.toUpperCase()))).toList(),
                onChanged: (val) => setStateSheet(() => selectedStatus = val!),
              ),
              const SizedBox(height: 12),
              TextField(controller: notesController, decoration: const InputDecoration(labelText: 'Notes (optional)', border: OutlineInputBorder())),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedStudentId != null && selectedClassroomId != null) {
                      widget.cubit.recordAttendance({
                        'student_id': int.parse(selectedStudentId!),
                        'classroom_id': int.parse(selectedClassroomId!),
                        'date': selectedDate.toString().substring(0, 10),
                        'status': selectedStatus,
                        if (notesController.text.isNotEmpty) 'notes': notesController.text,
                      });
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB)),
                  child: const Text('Record', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditAttendanceDialog(TeacherAttendanceModel a) {
    String selectedStatus = a.status;
    final notesController = TextEditingController(text: a.notes ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => StatefulBuilder(
        builder: (context, setStateSheet) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(child: Text('Edit Attendance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600))),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
                items: ['present', 'absent', 'late', 'excused'].map((s) =>
                  DropdownMenuItem(value: s, child: Text(s.toUpperCase()))).toList(),
                onChanged: (val) => setStateSheet(() => selectedStatus = val!),
              ),
              const SizedBox(height: 12),
              TextField(controller: notesController, decoration: const InputDecoration(labelText: 'Notes', border: OutlineInputBorder())),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    widget.cubit.updateAttendance(a.id, {
                      'status': selectedStatus,
                      'notes': notesController.text,
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB)),
                  child: const Text('Update', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ── GRADES ─────────────────────────────────────────
  Widget _gradesSection() {
    return SliverPadding(
      padding: const EdgeInsets.all(24),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _section = 'menu'),
                child: const Icon(Icons.arrow_back, color: Color(0xFF374151)),
              ),
              const SizedBox(width: 12),
              const Text('Grades', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _showCreateGradeDialog(),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (widget.state.grades.isEmpty)
            const Center(child: Padding(
              padding: EdgeInsets.all(48),
              child: Text('No grades recorded', style: TextStyle(color: Colors.grey)),
            ))
          else
            ...widget.state.grades.map((g) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: _cardDecoration(),
              child: Row(
                children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(g.grade ?? '${g.score}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue.shade700)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(g.studentName ?? 'Student #${g.studentId}',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF374151))),
                        const SizedBox(height: 2),
                        Text('${g.examName ?? 'Exam #${g.examId}'} · Score: ${g.score}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        if (g.remarks != null)
                          Text(g.remarks!, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    icon: const Icon(Icons.more_vert, size: 18, color: Colors.grey),
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
                    ],
                    onSelected: (val) {
                      if (val == 'delete') widget.cubit.deleteGrade(g.id);
                    },
                  ),
                ],
              ),
            )),
          const SizedBox(height: 80),
        ]),
      ),
    );
  }

  void _showCreateGradeDialog() {
    String? selectedStudentId;
    String? selectedExamId;
    final scoreController = TextEditingController();
    final remarksController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => StatefulBuilder(
        builder: (context, setStateSheet) => SingleChildScrollView(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(child: Text('Add Grade', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600))),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Student *', border: OutlineInputBorder()),
                items: widget.state.students.map((s) =>
                  DropdownMenuItem(value: s.id.toString(), child: Text(s.name))).toList(),
                onChanged: (val) => setStateSheet(() => selectedStudentId = val),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Exam *', border: OutlineInputBorder()),
                items: widget.state.exams.map((e) =>
                  DropdownMenuItem(value: e.id.toString(), child: Text(e.name))).toList(),
                onChanged: (val) => setStateSheet(() => selectedExamId = val),
              ),
              const SizedBox(height: 12),
              TextField(controller: scoreController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Score *', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: remarksController, decoration: const InputDecoration(labelText: 'Remarks (optional)', border: OutlineInputBorder())),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedStudentId != null && selectedExamId != null && scoreController.text.isNotEmpty) {
                      widget.cubit.createGrade({
                        'student_id': int.parse(selectedStudentId!),
                        'exam_id': int.parse(selectedExamId!),
                        'score': int.parse(scoreController.text),
                        if (remarksController.text.isNotEmpty) 'remarks': remarksController.text,
                      });
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB)),
                  child: const Text('Save Grade', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ── RESOURCES ──────────────────────────────────────
  Widget _resourcesSection() {
    return SliverPadding(
      padding: const EdgeInsets.all(24),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _section = 'menu'),
                child: const Icon(Icons.arrow_back, color: Color(0xFF374151)),
              ),
              const SizedBox(width: 12),
              const Text('Resources', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
            ],
          ),
          const SizedBox(height: 16),
          if (widget.state.resources.isEmpty)
            const Center(child: Padding(
              padding: EdgeInsets.all(48),
              child: Text('No resources yet', style: TextStyle(color: Colors.grey)),
            ))
          else
            ...widget.state.resources.map((r) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: _cardDecoration(),
              child: Row(
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(color: Colors.teal.shade50, borderRadius: BorderRadius.circular(10)),
                    child: Icon(Icons.insert_drive_file, color: Colors.teal.shade600, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF374151))),
                        const SizedBox(height: 2),
                        Text('${r.type ?? 'file'} · ${r.visibility ?? 'public'}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        if (r.tags.isNotEmpty)
                          Text(r.tags.join(', '), style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    icon: const Icon(Icons.more_vert, size: 18, color: Colors.grey),
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
                    ],
                    onSelected: (val) {
                      if (val == 'delete') widget.cubit.deleteResource(r.id);
                    },
                  ),
                ],
              ),
            )),
          const SizedBox(height: 80),
        ]),
      ),
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
  );
}