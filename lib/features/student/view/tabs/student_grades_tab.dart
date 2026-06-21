import 'package:flutter/material.dart';
import 'package:school_test/features/student/data/models/student_grade_model.dart';
import 'package:school_test/features/student/view/items/subject_grade_item.dart';
import 'package:school_test/features/student/view_model/cubit/student_cubit.dart';

class StudentGradesTab extends StatefulWidget {
  final StudentLoaded state;
  const StudentGradesTab({super.key, required this.state});

  @override
  State<StudentGradesTab> createState() => _StudentGradesTabState();
}

class _StudentGradesTabState extends State<StudentGradesTab> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  List<StudentGradeModel> get _filteredGrades {
    final all = widget.state.grades;
    if (_searchQuery.isEmpty) return all;
    return all.where((g) =>
      (g.subjectName?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
      (g.examName?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false)
    ).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredGrades;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          const SizedBox(height: 16),
          const Text(
            'All Grades',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              hintText: 'Search by subject or exam...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
          const SizedBox(height: 16),
          if (filtered.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Text(
                  'No grades found',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            )
          else
            ...filtered.map((g) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SubjectGradeItem(grade: g),
                )),
          const SizedBox(height: 100),
        ]),
      ),
    );
  }
}