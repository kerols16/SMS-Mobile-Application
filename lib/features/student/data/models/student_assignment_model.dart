import 'package:equatable/equatable.dart';
import 'student_submission_model.dart';

class StudentAssignmentModel extends Equatable {
  final int id;
  final String title;
  final String? description;
  final int subjectId;
  final int classroomId;
  final int teacherId;
  final String assignedAt;
  final String dueAt;
  final int points;
  final bool submitted;
  final String? subjectName;
  final String? teacherName;
  final StudentSubmissionModel? submission;
  const StudentAssignmentModel({
    required this.id,
    required this.title,
    this.description,
    required this.subjectId,
    required this.classroomId,
    required this.teacherId,
    required this.assignedAt,
    required this.dueAt,
    required this.points,
    required this.submitted,
    this.subjectName,
    this.teacherName,
    this.submission,
  });

  factory StudentAssignmentModel.fromJson(Map<String, dynamic> json) {
    return StudentAssignmentModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      subjectId: json['subject_id'] as int? ?? 0,
      classroomId: json['classroom_id'] as int? ?? 0,
      teacherId: json['teacher_id'] as int? ?? 0,
      assignedAt: json['assigned_at'] as String? ?? '',
      dueAt: json['due_at'] as String? ?? '',
      points: json['points'] as int? ?? 0,
      submitted: json['submitted'] as bool? ?? false,
      subjectName: json['subject']?['name'] as String?,
      teacherName: json['teacher']?['user']?['name'] as String?,
      submission: json['submission'] != null
          ? StudentSubmissionModel.fromJson(json['submission'])
          : null,
    );
  }

  bool get isUrgent {
    if (dueAt.isEmpty) return false;
    final dueDate = DateTime.tryParse(dueAt);
    if (dueDate == null) return false;
    final difference = dueDate.difference(DateTime.now()).inDays;
    return difference <= 2 && difference >= 0;
  }

  String get status {
    if (submitted) return 'submitted';
    if (dueAt.isNotEmpty) {
      final dueDate = DateTime.tryParse(dueAt);
      if (dueDate != null && dueDate.isBefore(DateTime.now())) {
        return 'overdue';
      }
    }
    return 'pending';
  }

  @override
  List<Object?> get props => [id, title, dueAt, submitted];
}
