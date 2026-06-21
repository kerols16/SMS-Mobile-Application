// ═══ FILE: lib/features/teacher/data/models/assignment_model.dart ═══
import 'package:equatable/equatable.dart';

class AssignmentModel extends Equatable {
  final int id;
  final String title;
  final String? description;
  final int subjectId;
  final int classroomId;
  final int teacherId;
  final String dueDate;
  final int? totalMarks;
  final String status;
  final Map<String, dynamic>? subject;
  final Map<String, dynamic>? classroom;
  final Map<String, dynamic>? teacher;

  const AssignmentModel({
    required this.id,
    required this.title,
    this.description,
    required this.subjectId,
    required this.classroomId,
    required this.teacherId,
    required this.dueDate,
    this.totalMarks,
    required this.status,
    this.subject,
    this.classroom,
    this.teacher,
  });

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      subjectId: json['subject_id'] as int,
      classroomId: json['classroom_id'] as int,
      teacherId: json['teacher_id'] as int,
      dueDate: json['due_date'] as String,
      totalMarks: json['total_marks'] as int?,
      status: json['status'] as String,
      subject: json['subject'] as Map<String, dynamic>?,
      classroom: json['classroom'] as Map<String, dynamic>?,
      teacher: json['teacher'] as Map<String, dynamic>?,
    );
  }

  String get subjectName {
    return subject?['name'] as String? ?? 'Unknown Subject';
  }

  String get classroomName {
    return classroom?['name'] as String? ?? 'Unknown Classroom';
  }

  @override
  List<Object?> get props => [id, title, subjectId, classroomId, dueDate, status];
}