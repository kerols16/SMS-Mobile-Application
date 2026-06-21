import 'package:flutter/material.dart';
import 'package:school_test/features/student/data/models/student_grade_model.dart';

class GradeDetailPage extends StatelessWidget {
  final StudentGradeModel grade;
  const GradeDetailPage({super.key, required this.grade});

  @override
  Widget build(BuildContext context) {
    final score = grade.score ?? 0.0;
    final total = grade.totalMarks ?? 100.0;
    final percentage = total > 0 ? (score / total) * 100 : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(grade.subjectName ?? 'Grade Details'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF374151),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // بطاقة الدرجة
            Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Score',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$percentage%',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      color: _getColor(percentage),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${score.toStringAsFixed(1)} / ${total.toStringAsFixed(1)}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  _buildStatusBadge(percentage),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // تفاصيل الامتحان
            Container(
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
                    'Exam Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow('Exam Name', grade.examName ?? 'N/A'),
                  _buildDetailRow('Subject', grade.subjectName ?? 'N/A'),
                  _buildDetailRow('Total Marks', grade.totalMarks?.toString() ?? 'N/A'),
                  _buildDetailRow('Marks Obtained', grade.score?.toString() ?? 'N/A'),
                  if (grade.remarks != null) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Remarks',
                      style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF374151)),
                    ),
                    const SizedBox(height: 4),
                    Text(grade.remarks!, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Color _getColor(double percentage) {
    if (percentage >= 90) return Colors.green;
    if (percentage >= 80) return Colors.blue;
    if (percentage >= 70) return Colors.orange;
    return Colors.red;
  }

  Widget _buildStatusBadge(double percentage) {
    String status;
    Color color;
    if (percentage >= 90) {
      status = 'Excellent';
      color = Colors.green;
    } else if (percentage >= 80) {
      status = 'Very Good';
      color = Colors.blue;
    } else if (percentage >= 70) {
      status = 'Good';
      color = Colors.orange;
    } else if (percentage >= 60) {
      status = 'Satisfactory';
      color = Colors.orange.shade600;
    } else {
      status = 'Needs Improvement';
      color = Colors.red;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}