import 'package:equatable/equatable.dart';

class TeacherAssignmentModel extends Equatable {
  final int id;
  final int classroomId;
  final int subjectId;
  final int teacherId;
  final String title;
  final String? description;
  final String? assignedAt;
  final String? dueAt;
  final int points;
  final bool isActive;
  final int submissionCount;
  final String? createdAt;

  const TeacherAssignmentModel({
    required this.id,
    required this.classroomId,
    required this.subjectId,
    required this.teacherId,
    required this.title,
    this.description,
    this.assignedAt,
    this.dueAt,
    required this.points,
    required this.isActive,
    required this.submissionCount,
    this.createdAt,
  });

  factory TeacherAssignmentModel.fromJson(Map<String, dynamic> json) {
    return TeacherAssignmentModel(
      id: json['id'] as int,
      classroomId: json['classroom_id'] as int? ?? 0,
      subjectId: json['subject_id'] as int? ?? 0,
      teacherId: json['teacher_id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      assignedAt: json['assigned_at'] as String?,
      dueAt: json['due_at'] as String?,
      points: json['points'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      submissionCount: json['submission_count'] as int? ?? 0,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'classroom_id': classroomId,
    'subject_id': subjectId,
    'teacher_id': teacherId,
    'title': title,
    'description': description,
    'assigned_at': assignedAt,
    'due_at': dueAt,
    'points': points,
    'is_active': isActive,
    'submission_count': submissionCount,
    'created_at': createdAt,
  };

  @override
  List<Object?> get props => [
    id, classroomId, subjectId, teacherId, title,
    description, assignedAt, dueAt, points, isActive,
    submissionCount, createdAt,
  ];
}