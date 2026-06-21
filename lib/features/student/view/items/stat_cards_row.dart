import 'package:flutter/material.dart';
import '../../../../features/student/data/models/student_dashboard_model.dart';
import '../../../../features/student/data/models/student_attendance_model.dart';

class StatCardsRow extends StatelessWidget {
  final StudentDashboardModel dashboard;
  final StudentAttendanceSummaryModel attendanceSummary;

  const StatCardsRow({
    super.key,
    required this.dashboard,
    required this.attendanceSummary,
  });

@override
Widget build(BuildContext context) {
  final presentCount = attendanceSummary.byStatus['present'] ?? 0;
  final totalRecords = attendanceSummary.totalRecords;
  final attendancePercentage = (attendanceSummary.attendanceRate * 100).toStringAsFixed(1);

  return Row(
    children: [
      Expanded(
        child: _StatCard(
          icon: Icons.grade,
          color: Colors.green,
          value: '${dashboard.averageScore.toStringAsFixed(1)}%',
          label: 'Overall Average',
          trailing: const Icon(Icons.trending_up, color: Colors.green, size: 16),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: _StatCard(
          icon: Icons.check_circle,
          color: Colors.blue,
          value: '$presentCount/$totalRecords',
          label: 'Attendance Rate',
          trailing: Text(
            '$attendancePercentage%',
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ],
  );
}
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;
  final Widget trailing;

  const _StatCard({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 32),
              trailing,
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}