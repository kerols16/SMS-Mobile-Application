import 'package:flutter/material.dart';
import 'package:school_test/features/student/data/models/student_assignment_model.dart';
import 'package:school_test/features/student/view_model/cubit/student_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssignmentDetailPage extends StatefulWidget {
  final StudentAssignmentModel assignment;
  const AssignmentDetailPage({super.key, required this.assignment});

  @override
  State<AssignmentDetailPage> createState() => _AssignmentDetailPageState();
}

class _AssignmentDetailPageState extends State<AssignmentDetailPage> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _filePathController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _contentController.dispose();
    _filePathController.dispose();
    super.dispose();
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
    final assignment = widget.assignment;
    final isSubmitted = assignment.submitted;

    return Scaffold(
      appBar: AppBar(
        title: Text(assignment.title),
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromARGB(255, 0, 3, 7),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // معلومات الواجب
            _buildInfoCard(assignment),
            const SizedBox(height: 24),

            // حالة التسليم
            _buildSubmissionStatus(assignment),
            const SizedBox(height: 24),

            // نموذج التسليم (إذا لم يتم التسليم)
            if (!isSubmitted) _buildSubmissionForm(assignment),
            if (!isSubmitted) const SizedBox(height: 24),

            // معلومات المعلم والفصل
            _buildTeacherClassroomInfo(assignment),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(StudentAssignmentModel assignment) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Assignment Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 0, 6, 15),
            ),
          ),
          const SizedBox(height: 12),
          _buildDetailRow('Subject', assignment.subjectName ?? 'N/A'),
          _buildDetailRow('Assigned At', _formatDate(assignment.assignedAt)),
          _buildDetailRow('Due Date', _formatDate(assignment.dueAt)),
          _buildDetailRow('Points', assignment.points.toString()),
          if (assignment.description != null) ...[
            const SizedBox(height: 8),
            const Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.w500, color: Color.fromARGB(255, 0, 0, 0)),
            ),
            const SizedBox(height: 4),
            Text(
              assignment.description!,
              style: const TextStyle(fontSize: 14, color: Color.fromARGB(255, 0, 0, 0)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Color.fromARGB(255, 0, 0, 0))),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildSubmissionStatus(StudentAssignmentModel assignment) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: assignment.submitted ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: assignment.submitted ? Colors.green.shade200 : Colors.orange.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            assignment.submitted ? Icons.check_circle : Icons.pending,
            color: assignment.submitted ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 8),
          Text(
            assignment.submitted ? 'Submitted' : 'Not Submitted Yet',
            style: TextStyle(
              color: assignment.submitted ? Colors.green : Colors.orange,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          if (assignment.submitted && assignment.submission != null)
            Text(
              'Score: ${assignment.submission!.score?.toString() ?? 'Pending'}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
        ],
      ),
    );
  }

  Widget _buildSubmissionForm(StudentAssignmentModel assignment) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Submit Your Assignment',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _contentController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Content',
              hintText: 'Write your answer here...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _filePathController,
            decoration: const InputDecoration(
              labelText: 'File Path (optional)',
              hintText: 'e.g., submissions/my-work.pdf',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: _isSubmitting
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: () => _submitAssignment(context, assignment.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Submit Now', style: TextStyle(color: Colors.white)),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherClassroomInfo(StudentAssignmentModel assignment) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              const Icon(Icons.person, color: Color.fromARGB(255, 3, 0, 192)),
              const SizedBox(height: 4),
              Text(
                assignment.teacherName ?? 'Unknown',
                style: const TextStyle(fontSize: 12, color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ],
          ),
          Column(
            children: [
              const Icon(Icons.class_, color: Color.fromARGB(255, 252, 194, 3)),
              const SizedBox(height: 4),
              Text(
                'Class ${assignment.classroomId}',
                style: const TextStyle(fontSize: 12, color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _submitAssignment(BuildContext context, int assignmentId) async {
    if (_contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your content'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final data = {
        'content': _contentController.text,
        'file_path': _filePathController.text.isNotEmpty ? _filePathController.text : null,
      };
      await context.read<StudentCubit>().submitAssignment(assignmentId, data);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Assignment submitted successfully'), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}