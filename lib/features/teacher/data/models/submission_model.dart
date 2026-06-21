import 'package:equatable/equatable.dart';

class AssignmentModel extends Equatable {
  final int id;
  final String title;
  final String? description;
  final int subjectId;
  final String subjectName;
  final int classroomId;
  final String classroomName;
  final String dueDate;
  final int? totalMarks;
  final String status; // 'active', 'draft', 'closed'

  const AssignmentModel({
    required this.id,
    required this.title,
    this.description,
    required this.subjectId,
    required this.subjectName,
    required this.classroomId,
    required this.classroomName,
    required this.dueDate,
    this.totalMarks,
    required this.status,
  });

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      subjectId: json['subject_id'] as int,
      subjectName: json['subject_name'] as String? ?? 'Subject ${json['subject_id']}',
      classroomId: json['classroom_id'] as int,
      classroomName: json['classroom_name'] as String? ?? 'Classroom ${json['classroom_id']}',
      dueDate: json['due_date'] as String,
      totalMarks: json['total_marks'] as int?,
      status: json['status'] as String? ?? 'active',
    );
  }

  @override
  List<Object?> get props => [id, title, dueDate, status];
}