import 'package:flutter/material.dart';
import 'package:school_test/features/admin/veiw_model/cubit/admin_cubit.dart';
import 'package:school_test/features/admin/view/academics_sections/attendance_section.dart';
import 'package:school_test/features/admin/view/academics_sections/exams_section.dart';
import 'package:school_test/features/admin/view/academics_sections/grades_section.dart';
import 'package:school_test/features/admin/view/academics_sections/overview_section.dart';


class AcademicsTab extends StatefulWidget {
  final AdminLoaded state;
  final bool isSuperAdmin;

  const AcademicsTab({
    super.key,
    required this.state,
    required this.isSuperAdmin,
  });

  @override
  State<AcademicsTab> createState() => _AcademicsTabState();
}

class _AcademicsTabState extends State<AcademicsTab> {
  int _selectedIndex = 0;

  final _labels = ['Overview', 'Attendance', 'Grades', 'Exams'];

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        // ── Chip Selector ──────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_labels.length, (i) {
                  final isSelected = _selectedIndex == i;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedIndex = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Color(0xFF2563EB)
                              : Color(0xFF2563EB).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _labels[i],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Colors.white : Color(0xFF1E40AF),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),

        // ── Content ────────────────────────────────────
        if (_selectedIndex == 0)
          OverviewSection(
              state: widget.state, isSuperAdmin: widget.isSuperAdmin),
        if (_selectedIndex == 1)
          AttendanceSection(
              state: widget.state, isSuperAdmin: widget.isSuperAdmin),
        if (_selectedIndex == 2)
          GradesSection(
              state: widget.state, isSuperAdmin: widget.isSuperAdmin),
        if (_selectedIndex == 3)
          ExamsSection(
              state: widget.state, isSuperAdmin: widget.isSuperAdmin),
      ],
    );
  }
}