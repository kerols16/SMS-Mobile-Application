import 'package:equatable/equatable.dart';

class TeacherExamModel extends Equatable {
  final int id;
  final String name;
  final String type; 
  final int? subjectId;
  final String? subjectName;
  final int? classroomId;
  final String? classroomName;
  final int maxScore;
  final String? scheduledAt;
  final int? durationMinutes;
  final bool isOnline;
  final String? instructions;
  final String? createdAt;

  const TeacherExamModel({
    required this.id,
    required this.name,
    required this.type,
    this.subjectId,
    this.subjectName,
    this.classroomId,
    this.classroomName,
    required this.maxScore,
    this.scheduledAt,
    this.durationMinutes,
    required this.isOnline,
    this.instructions,
    this.createdAt,
  });

  factory TeacherExamModel.fromJson(Map<String, dynamic> json) {
    return TeacherExamModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? 'other',
      subjectId: json['subject_id'] as int?,
      subjectName: (json['subject'] as Map<String, dynamic>?)?['name'] as String?,
      classroomId: json['classroom_id'] as int?,
      classroomName: (json['classroom'] as Map<String, dynamic>?)?['name'] as String?,
      maxScore: json['max_score'] as int? ?? 100,
      scheduledAt: json['scheduled_at'] as String?,
      durationMinutes: json['duration_minutes'] as int?,
      isOnline: json['is_online'] as bool? ?? false,
      instructions: json['instructions'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'subject_id': subjectId,
    'subject_name': subjectName,
    'classroom_id': classroomId,
    'classroom_name': classroomName,
    'max_score': maxScore,
    'scheduled_at': scheduledAt,
    'duration_minutes': durationMinutes,
    'is_online': isOnline,
    'instructions': instructions,
    'created_at': createdAt,
  };

  @override
  List<Object?> get props => [
    id, name, type, subjectId, subjectName, classroomId,
    classroomName, maxScore, scheduledAt, durationMinutes,
    isOnline, instructions, createdAt,
  ];
}