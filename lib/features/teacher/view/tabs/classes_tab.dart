import 'package:flutter/material.dart';
import 'package:school_test/features/teacher/data/models/teacher_classroom_model.dart';
import 'package:school_test/features/teacher/view_model/cubit/teacher_cubit.dart';

class ClassesTab extends StatelessWidget {
  final TeacherLoaded state;
  const ClassesTab({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(24),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          const Text(
            'My Classes',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF374151)),
          ),
          const SizedBox(height: 8),
          Text(
            '${state.classrooms.length} classrooms · ${state.totalStudents} students total',
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          if (state.classrooms.isEmpty)
            const Center(child: Text('No classrooms assigned', style: TextStyle(color: Colors.grey)))
          else
            ...state.classrooms.map((c) => _classCard(context, c)),
          const SizedBox(height: 80),
        ]),
      ),
    );
  }

  Widget _classCard(BuildContext context, TeacherClassroomModel c) {
    final classAssignments = state.assignments.where((a) => a.classroomId == c.id).toList();
    final classExams = state.exams.where((e) => e.classroomId == c.id).toList();

    return GestureDetector(
      onTap: () => _showDetails(context, c, classAssignments, classExams),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.menu_book, color: Colors.blue.shade600, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
                      const SizedBox(height: 2),
                      Text('Grade ${c.gradeLevel}', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: c.isActive ? Colors.green.shade50 : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    c.isActive ? 'Active' : 'Inactive',
                    style: TextStyle(fontSize: 12, color: c.isActive ? Colors.green.shade700 : Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _stat('${c.capacity}', 'Students', Colors.blue)),
                Expanded(child: _stat('${c.capacity}', 'Capacity', Colors.green)),
                Expanded(child: _stat('${classAssignments.length}', 'Assignments', Colors.orange)),
                Expanded(child: _stat('${classExams.length}', 'Exams', Colors.purple)),
              ],
            ),
            if (c.description != null && c.description!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(c.description!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _stat(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(color: color.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: color)),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  void _showDetails(BuildContext context, TeacherClassroomModel c, assignments, exams) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 16),
                Text(c.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('${c.capacity} students · Capacity ${c.capacity} · Year ${c.description}', style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 24),

                // Students
                const Text('Students', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                ...state.students.take(5).map((s) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue.shade100, radius: 18,
                        child: Text(s.name.isNotEmpty ? s.name[0] : 'S', style: const TextStyle(color: Colors.blue)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                            Text(s.email, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                          ],
                        ),
                      ),
                      Text(s.studentId, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                )),

                if (assignments.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  const Text('Assignments', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  ...assignments.map((a) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Expanded(child: Text(a.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
                        Text('${a.submissionCount} submitted', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  )),
                ],

                if (exams.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  const Text('Exams', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  ...exams.map((e) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.purple.shade50, borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Expanded(child: Text(e.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
                        Text(e.type.toUpperCase(), style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  )),
                ],

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}