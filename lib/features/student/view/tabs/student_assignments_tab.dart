import 'package:flutter/material.dart';
import 'package:school_test/features/student/data/models/student_assignment_model.dart';
import 'package:school_test/features/student/view/items/assignment_item.dart';
import 'package:school_test/features/student/view_model/cubit/student_cubit.dart';

class StudentAssignmentsTab extends StatefulWidget {
  final StudentLoaded state;
  const StudentAssignmentsTab({super.key, required this.state});

  @override
  State<StudentAssignmentsTab> createState() => _StudentAssignmentsTabState();
}

class _StudentAssignmentsTabState extends State<StudentAssignmentsTab> {
  String _filter = 'all'; // all, pending, submitted
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  List<StudentAssignmentModel> get _filteredAssignments {
    final all = widget.state.assignments;
    // تصفية حسب الحالة
    List<StudentAssignmentModel> filtered;
    if (_filter == 'pending') {
      filtered = all.where((a) => !a.submitted).toList();
    } else if (_filter == 'submitted') {
      filtered = all.where((a) => a.submitted).toList();
    } else {
      filtered = all;
    }
    // تصفية حسب البحث
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((a) =>
        a.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        (a.subjectName?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false)
      ).toList();
    }
    return filtered;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredAssignments;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          const SizedBox(height: 16),
          // العنوان والفلتر
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'All Assignments',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
              DropdownButton<String>(
                value: _filter,
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('All')),
                  DropdownMenuItem(value: 'pending', child: Text('Pending')),
                  DropdownMenuItem(value: 'submitted', child: Text('Submitted')),
                ],
                onChanged: (value) {
                  setState(() => _filter = value!);
                },
                underline: const SizedBox(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // حقل البحث
          TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              hintText: 'Search assignments...',
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
                  'No assignments found',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            )
          else
            ...filtered.map((a) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: AssignmentItem(assignment: a),
                )),
          const SizedBox(height: 100),
        ]),
      ),
    );
  }
}