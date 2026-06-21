import 'package:flutter/material.dart';
import 'package:school_test/features/student/view/items/subject_grade_item.dart';
import '../../../../features/student/data/models/student_grade_model.dart';

class RecentGradesCard extends StatelessWidget {
  final List<StudentGradeModel> grades;
  const RecentGradesCard({super.key, required this.grades});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Recent Grades',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
              
            ],
          ),
          const SizedBox(height: 16),
          if (grades.isEmpty)
            const Text(
              'No grades yet',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            )
          else
            ...grades.map((g) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SubjectGradeItem(grade: g),
                )),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      );
}