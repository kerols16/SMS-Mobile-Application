import 'package:equatable/equatable.dart';

class AssignmentModel extends Equatable {
  final int id;
  final String title;
  final String description;
  final int subjectId;
  final int classroomId;
  final int teacherId;
  final String dueDate;        // YYYY-MM-DD
  final int totalMarks;
  final String? createdAt;
  final String? updatedAt;

  const AssignmentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.subjectId,
    required this.classroomId,
    required this.teacherId,
    required this.dueDate,
    required this.totalMarks,
    this.createdAt,
    this.updatedAt,
  });

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      subjectId: json['subject_id'] as int,
      classroomId: json['classroom_id'] as int,
      teacherId: json['teacher_id'] as int,
      dueDate: json['due_date'] as String,
      totalMarks: json['total_marks'] as int,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'subject_id': subjectId,
      'classroom_id': classroomId,
      'teacher_id': teacherId,
      'due_date': dueDate,
      'total_marks': totalMarks,
    };
  }

  @override
  List<Object?> get props => [id, title, description, subjectId, classroomId, teacherId, dueDate, totalMarks];
}