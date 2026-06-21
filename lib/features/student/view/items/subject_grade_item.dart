import 'package:flutter/material.dart';
import 'package:school_test/features/student/view/screens/grade_detail_page.dart';
import '../../../../features/student/data/models/student_grade_model.dart';

class SubjectGradeItem extends StatelessWidget {
  final StudentGradeModel grade;
  final VoidCallback? onTap;
  const SubjectGradeItem({super.key, required this.grade, this.onTap});

  @override
  Widget build(BuildContext context) {
    final score = grade.score ?? 0.0;
    final total = grade.totalMarks ?? 100.0;
    final percentage = total > 0 ? (score / total) * 100 : 0.0;
    final displayValue = percentage.toStringAsFixed(0);

    Color color;
    if (percentage >= 90) {
      color = Colors.green;
    } else if (percentage >= 80) {
      color = Colors.blue;
    } else if (percentage >= 70) {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }

    final subjectName = grade.subjectName ?? 'Unknown Subject';
    final examName = grade.examName ?? 'Exam';

    return GestureDetector(
      onTap:
          onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => GradeDetailPage(grade: grade)),
            );
          },
      child: Container(
        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.menu_book, color: Colors.blue, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subjectName,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    examName,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Text(
              '$displayValue%',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
