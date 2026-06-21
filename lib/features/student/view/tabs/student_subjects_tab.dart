import 'package:flutter/material.dart';
import 'package:school_test/features/student/view_model/cubit/student_cubit.dart';

class StudentSubjectsTab extends StatelessWidget {
  final StudentLoaded state;
  const StudentSubjectsTab({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          const SizedBox(height: 16),
          const Text(
            'My Subjects',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 16),
          if (state.subjects.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Text(
                  'No subjects found',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            )
          else
            ...state.subjects.map((subject) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.all(16),
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
                        Text(
                          subject.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF374151),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Code: ${subject.code} • Credits: ${subject.credits}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        if (subject.description != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            subject.description!,
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                        if (subject.teachers.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Teachers: ${subject.teachers.map((t) => t.name).toSet().join(', ')}',
                            style: const TextStyle(fontSize: 12, color: Colors.blue),
                          ),
                        ],
                      ],
                    ),
                  ),
                )),
          const SizedBox(height: 100),
        ]),
      ),
    );
  }
}