import 'package:flutter/material.dart';
import 'package:school_test/features/teacher/view_model/cubit/teacher_cubit.dart';

class HomeTab extends StatelessWidget {
  final TeacherLoaded state;
  const HomeTab({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final pendingSubmissions = state.submissions.where((s) => !s.isGraded).toList();
    final upcomingExams = state.exams.take(3).toList();
    final recentAssignments = state.assignments.take(3).toList();

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          // ── Stats Row ──────────────────────────────────
          Row(
            children: [
              Expanded(child: _statCard('${state.classrooms.length}', 'Classes', Colors.blue, Icons.school)),
              const SizedBox(width: 10),
              Expanded(child: _statCard('${state.totalStudents}', 'Students', Colors.green, Icons.people)),
              const SizedBox(width: 10),
              Expanded(child: _statCard('${state.unreadMessageCount}', 'Unread', Colors.orange, Icons.message)),
              const SizedBox(width: 10),
              Expanded(child: _statCard('${pendingSubmissions.length}', 'To Grade', Colors.red, Icons.grading)),
            ],
          ),

          const SizedBox(height: 24),

          // ── Pending Submissions ────────────────────────
          if (pendingSubmissions.isNotEmpty) ...[
            _sectionHeader('Pending to Grade', '${pendingSubmissions.length}'),
            const SizedBox(height: 12),
            ...pendingSubmissions.take(3).map((s) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: _cardDecoration(),
              child: Row(
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.assignment_turned_in, color: Colors.orange.shade600, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.studentName ?? 'Student',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF374151)),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Assignment #${s.assignmentId}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Grade',
                      style: TextStyle(fontSize: 12, color: Colors.orange.shade700),
                    ),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 24),
          ],

          // ── Recent Assignments ─────────────────────────
          if (recentAssignments.isNotEmpty) ...[
            _sectionHeader('Recent Assignments', '${state.assignments.length} total'),
            const SizedBox(height: 12),
            ...recentAssignments.map((a) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: _cardDecoration(),
              child: Row(
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.assignment, color: Colors.blue.shade600, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          a.title,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF374151)),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${a.submissionCount} submissions · ${a.points} pts',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: a.isActive ? Colors.green.shade50 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      a.isActive ? 'Active' : 'Closed',
                      style: TextStyle(
                        fontSize: 12,
                        color: a.isActive ? Colors.green.shade700 : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 24),
          ],

          // ── Upcoming Exams ─────────────────────────────
          if (upcomingExams.isNotEmpty) ...[
            _sectionHeader('Upcoming Exams', '${state.exams.length} total'),
            const SizedBox(height: 12),
            ...upcomingExams.map((e) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: _cardDecoration(),
              child: Row(
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.quiz, color: Colors.purple.shade600, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.name,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF374151)),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${e.type.toUpperCase()} · ${e.maxScore} pts · ${e.scheduledAt?.substring(0, 10) ?? 'TBD'}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  if (e.isOnline)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('Online', style: TextStyle(fontSize: 11, color: Colors.blue.shade700)),
                    ),
                ],
              ),
            )),
            const SizedBox(height: 24),
          ],

          // ── Resources ─────────────────────────────────
          if (state.resources.isNotEmpty) ...[
            _sectionHeader('My Resources', '${state.resources.length} total'),
            const SizedBox(height: 12),
            ...state.resources.take(3).map((r) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: _cardDecoration(),
              child: Row(
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.folder, color: Colors.teal.shade600, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r.title,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF374151)),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${r.type ?? 'file'} · ${r.visibility ?? 'public'}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  if (r.tags.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(r.tags.first, style: TextStyle(fontSize: 11, color: Colors.teal.shade700)),
                    ),
                ],
              ),
            )),
            const SizedBox(height: 24),
          ],

          const SizedBox(height: 80),
        ]),
      ),
    );
  }

  Widget _sectionHeader(String title, String subtitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF374151)),
        ),
        Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _statCard(String value, String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color),
          ),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2)),
    ],
  );
}