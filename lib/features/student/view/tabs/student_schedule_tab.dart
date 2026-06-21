import 'package:flutter/material.dart';
import 'package:school_test/features/student/view/cards/exam_countdown_card.dart';
import 'package:school_test/features/student/view/items/schedule_lesson_item.dart';
import 'package:school_test/features/student/view_model/cubit/student_cubit.dart';

class StudentScheduleTab extends StatefulWidget {
  final StudentLoaded state;
  const StudentScheduleTab({super.key, required this.state});

  @override
  State<StudentScheduleTab> createState() => _StudentScheduleTabState();
}

class _StudentScheduleTabState extends State<StudentScheduleTab> {
  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
  String _selectedDay = 'Mon';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.state.schedule
        .where((s) => s.dayOfWeek == _selectedDay)
        .toList();

    final upcomingExam = widget.state.exams.isNotEmpty
        ? widget.state.exams.first
        : null;

    return SliverPadding(
      padding: const EdgeInsets.all(24),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          const Text(
            'Weekly Schedule',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 24),

          // Day Selector
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _days.map((day) {
                final isSelected = day == _selectedDay;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedDay = day),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF2563EB)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : Colors.grey.shade200,
                        ),
                      ),
                      child: Text(
                        day,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 24),

          // Lessons
          if (filtered.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'No classes this day',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            ...filtered.map((lesson) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ScheduleLessonItem(schedule: lesson),
                )),

          const SizedBox(height: 24),

          if (upcomingExam != null)
            ExamCountdownCard(exam: upcomingExam),

         SizedBox(height: MediaQuery.of(context).padding.bottom + 80),
        ]),
      ),
    );
  }
}