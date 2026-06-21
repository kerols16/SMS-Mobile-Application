import 'package:flutter/material.dart';
import 'package:school_test/features/student/view_model/cubit/student_cubit.dart';

class StudentTeachersTab extends StatelessWidget {
  final StudentLoaded state;
  const StudentTeachersTab({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          const SizedBox(height: 16),
          const Text(
            'My Teachers',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 16),
          if (state.teachers.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Text(
                  'No teachers found',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            )
          else
            ...state.teachers.map((teacher) => Padding(
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
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: Text(
                            teacher.name.isNotEmpty ? teacher.name[0].toUpperCase() : 'T',
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                teacher.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF374151),
                                ),
                              ),
                              if (teacher.email != null)
                                Text(
                                  teacher.email!,
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              if (teacher.subjectName != null)
                                Text(
                                  'Subject: ${teacher.subjectName}',
                                  style: const TextStyle(fontSize: 12, color: Colors.blue),
                                ),
                            ],
                          ),
                        ),
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