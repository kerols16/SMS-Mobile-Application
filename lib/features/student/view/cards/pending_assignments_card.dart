import 'package:flutter/material.dart';
import 'package:school_test/features/student/view/items/assignment_item.dart';
import '../../../../features/student/data/models/student_assignment_model.dart';

class PendingAssignmentsCard extends StatelessWidget {
  final List<StudentAssignmentModel> assignments;
  const PendingAssignmentsCard({super.key, required this.assignments});

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
                'Pending Assignments',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
              
            ],
          ),
          const SizedBox(height: 16),
          if (assignments.isEmpty)
            const Text(
              'No pending assignments 🎉',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            )
          else
            ...assignments.map((a) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: AssignmentItem(assignment: a),
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