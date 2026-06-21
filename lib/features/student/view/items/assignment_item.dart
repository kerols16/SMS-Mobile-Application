import 'package:flutter/material.dart';
import 'package:school_test/features/student/view/screens/assignment_detail_page.dart';
import '../../../../features/student/data/models/student_assignment_model.dart';

class AssignmentItem extends StatelessWidget {
  final StudentAssignmentModel assignment;
  final VoidCallback? onTap;
  const AssignmentItem({super.key, required this.assignment, this.onTap});

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
    final isUrgent = assignment.isUrgent;
    final isSubmitted = assignment.submitted;

    return GestureDetector(
      onTap:
          onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AssignmentDetailPage(assignment: assignment),
              ),
            );
          },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSubmitted
              ? Colors.green.shade50
              : isUrgent
              ? Colors.red.shade50
              : Colors.grey.shade50,
          border: Border.all(
            color: isSubmitted
                ? Colors.green.shade200
                : isUrgent
                ? Colors.red.shade200
                : Colors.grey.shade200,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    assignment.title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    assignment.subjectName ?? '',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(assignment.dueAt), // ← التاريخ المنسق
                    style: TextStyle(
                      fontSize: 11,
                      color: isSubmitted
                          ? Colors.green
                          : isUrgent
                          ? Colors.red
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (isUrgent)
              const Icon(Icons.warning, color: Colors.red, size: 20)
            else if (isSubmitted)
              const Icon(Icons.check_circle, color: Colors.green, size: 20),
          ],
        ),
      ),
    );
  }
}