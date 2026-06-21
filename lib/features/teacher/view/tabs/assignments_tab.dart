import 'package:flutter/material.dart';
import 'package:school_test/features/teacher/data/models/teacher_assignment_model.dart';
import 'package:school_test/features/teacher/data/models/teacher_submission_model.dart';
import 'package:school_test/features/teacher/view_model/cubit/teacher_cubit.dart';

class AssignmentsTab extends StatefulWidget {
  final TeacherLoaded state;
  final TeacherCubit cubit;
  const AssignmentsTab({super.key, required this.state, required this.cubit});

  @override
  State<AssignmentsTab> createState() => _AssignmentsTabState();
}

class _AssignmentsTabState extends State<AssignmentsTab> {
  String _filter = 'all'; // all | active | closed

  @override
  Widget build(BuildContext context) {
    final filtered = widget.state.assignments.where((a) {
      if (_filter == 'active') return a.isActive;
      if (_filter == 'closed') return !a.isActive;
      return true;
    }).toList();

    final pendingGrade = widget.state.submissions.where((s) => !s.isGraded).length;

    return SliverPadding(
      padding: const EdgeInsets.all(24),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Assignments', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
              ElevatedButton.icon(
                onPressed: () => _showCreateDialog(context),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('New'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),

          if (pendingGrade > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.pending_actions, color: Colors.orange.shade700, size: 20),
                  const SizedBox(width: 8),
                  Text('$pendingGrade submissions waiting to be graded',
                      style: TextStyle(color: Colors.orange.shade700, fontSize: 13)),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Filter
          Row(
            children: ['all', 'active', 'closed'].map((f) {
              final isSelected = _filter == f;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _filter = f),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF2563EB) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade200),
                    ),
                    child: Text(
                      f.toUpperCase(),
                      style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : Colors.grey.shade600),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          if (filtered.isEmpty)
            const Center(child: Padding(
              padding: EdgeInsets.all(48),
              child: Text('No assignments', style: TextStyle(color: Colors.grey)),
            ))
          else
            ...filtered.map((a) => _assignmentCard(context, a)),

          const SizedBox(height: 80),
        ]),
      ),
    );
  }

  Widget _assignmentCard(BuildContext context, TeacherAssignmentModel a) {
    final subs = widget.state.submissions.where((s) => s.assignmentId == a.id).toList();
    final graded = subs.where((s) => s.isGraded).length;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(a.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: a.isActive ? Colors.green.shade50 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  a.isActive ? 'Active' : 'Closed',
                  style: TextStyle(fontSize: 11, color: a.isActive ? Colors.green.shade700 : Colors.grey),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.star, size: 14, color: Colors.amber.shade600),
              const SizedBox(width: 4),
              Text('${a.points} pts', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(width: 16),
              Icon(Icons.assignment_turned_in, size: 14, color: Colors.blue.shade400),
              const SizedBox(width: 4),
              Text('$graded/${a.submissionCount} graded', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              if (a.dueAt != null) ...[
                const SizedBox(width: 16),
                Icon(Icons.schedule, size: 14, color: Colors.grey.shade400),
                const SizedBox(width: 4),
                Text(a.dueAt!.substring(0, 10), style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ],
          ),
          if (subs.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text('Submissions', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
            const SizedBox(height: 8),
            ...subs.map((s) => _submissionItem(context, s)),
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () => _showEditDialog(context, a),
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('Edit'),
                style: TextButton.styleFrom(foregroundColor: Colors.blue),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () => _confirmDelete(context, a.id, a.title),
                icon: const Icon(Icons.delete, size: 16),
                label: const Text('Delete'),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _submissionItem(BuildContext context, TeacherSubmissionModel s) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: s.isGraded ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: Colors.blue.shade100,
            child: Text(
              (s.studentName ?? 'S').isNotEmpty ? (s.studentName ?? 'S')[0] : 'S',
              style: const TextStyle(fontSize: 12, color: Colors.blue),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.studentName ?? 'Student', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                if (s.isGraded)
                  Text('Score: ${s.score} · ${s.feedback ?? ''}',
                      style: TextStyle(fontSize: 11, color: Colors.green.shade700)),
              ],
            ),
          ),
          if (!s.isGraded)
            GestureDetector(
              onTap: () => _showGradeDialog(context, s),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Grade', style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
            )
          else
            GestureDetector(
              onTap: () => _showGradeDialog(context, s, isUpdate: true),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Edit Grade', style: TextStyle(color: Colors.green.shade700, fontSize: 12)),
              ),
            ),
        ],
      ),
    );
  }

  void _showGradeDialog(BuildContext context, TeacherSubmissionModel s, {bool isUpdate = false}) {
    final scoreController = TextEditingController(text: s.score?.toString() ?? '');
    final feedbackController = TextEditingController(text: s.feedback ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isUpdate ? 'Update Grade' : 'Grade Submission'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Student: ${s.studentName ?? 'Unknown'}', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            TextField(
              controller: scoreController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Score', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: feedbackController,
              decoration: const InputDecoration(labelText: 'Feedback', border: OutlineInputBorder()),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final score = int.tryParse(scoreController.text) ?? 0;
              if (isUpdate) {
                widget.cubit.updateSubmissionGrade(s.id, score: score, feedback: feedbackController.text);
              } else {
                widget.cubit.gradeSubmission(s.id, score: score, feedback: feedbackController.text);
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB)),
            child: Text(isUpdate ? 'Update' : 'Submit'),
          ),
        ],
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final pointsController = TextEditingController(text: '100');
    String? selectedClassroomId;
    String? selectedSubjectId;
    DateTime? dueDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => StatefulBuilder(
        builder: (context, setStateSheet) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: Text('New Assignment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600))),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Classroom *', border: OutlineInputBorder()),
                items: widget.state.classrooms.map((c) =>
                  DropdownMenuItem(value: c.id.toString(), child: Text(c.name))).toList(),
                onChanged: (val) => setStateSheet(() => selectedClassroomId = val),
              ),
              const SizedBox(height: 12),
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title *', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()), maxLines: 3),
              const SizedBox(height: 12),
              TextField(controller: pointsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Points', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 7)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) setStateSheet(() => dueDate = picked);
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(4)),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        dueDate != null ? dueDate!.toString().substring(0, 10) : 'Due Date (optional)',
                        style: TextStyle(color: dueDate != null ? Colors.black : Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedClassroomId != null && titleController.text.isNotEmpty) {
                      widget.cubit.createAssignment({
                        'classroom_id': int.parse(selectedClassroomId!),
                        'title': titleController.text,
                        'description': descController.text,
                        'points': int.tryParse(pointsController.text) ?? 100,
                        if (dueDate != null) 'due_at': dueDate!.toIso8601String(),
                      });
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB)),
                  child: const Text('Create Assignment', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, TeacherAssignmentModel a) {
    final titleController = TextEditingController(text: a.title);
    final descController = TextEditingController(text: a.description ?? '');
    final pointsController = TextEditingController(text: a.points.toString());
    bool isActive = a.isActive;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => StatefulBuilder(
        builder: (context, setStateSheet) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: Text('Edit Assignment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600))),
              const SizedBox(height: 16),
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()), maxLines: 3),
              const SizedBox(height: 12),
              TextField(controller: pointsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Points', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Active'),
                value: isActive,
                onChanged: (val) => setStateSheet(() => isActive = val),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    widget.cubit.updateAssignment(a.id, {
                      'title': titleController.text,
                      'description': descController.text,
                      'points': int.tryParse(pointsController.text) ?? a.points,
                      'is_active': isActive,
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

  void _confirmDelete(BuildContext context, int id, String title) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Assignment'),
        content: Text('Delete "$title"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () { widget.cubit.deleteAssignment(id); Navigator.pop(context); },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}