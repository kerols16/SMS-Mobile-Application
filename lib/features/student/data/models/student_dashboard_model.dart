import 'package:equatable/equatable.dart';

class StudentDashboardModel extends Equatable {
  final int subjectsCount;
  final int upcomingExams;
  final int pendingAssignments;
  final double averageScore;
  final Map<String, int>? attendance;

  const StudentDashboardModel({
    required this.subjectsCount,
    required this.upcomingExams,
    required this.pendingAssignments,
    required this.averageScore,
    this.attendance,
  });

  factory StudentDashboardModel.fromJson(Map<String, dynamic> json) {
    final stats = json['stats'] as Map<String, dynamic>? ?? {};
    
    // قراءة average_score بشكل آمن من String أو num
    double parseAverage(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return StudentDashboardModel(
      subjectsCount: stats['subjects_count'] as int? ?? 0,
      upcomingExams: stats['upcoming_exams'] as int? ?? 0,
      pendingAssignments: stats['pending_assignments'] as int? ?? 0,
      averageScore: parseAverage(stats['average_score']),
      attendance: (stats['attendance'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, v as int)),
    );
  }

  @override
  List<Object?> get props => [
        subjectsCount,
        upcomingExams,
        pendingAssignments,
        averageScore,
        attendance,
      ];
}