// lib/features/admin/data/models/exam_model.dart
import 'package:equatable/equatable.dart';

class ExamModel extends Equatable {
  final int id;
  final int subjectId;
  final int classroomId;
  final String name;
  final String type;
  final int maxScore;
  final String? scheduledAt;
  final int durationMinutes;
  final bool isOnline;
  final String? instructions;
  final String? createdAt;
  final String? updatedAt;

  const ExamModel({
    required this.id,
    required this.subjectId,
    required this.classroomId,
    required this.name,
    required this.type,
    required this.maxScore,
    this.scheduledAt,
    required this.durationMinutes,
    required this.isOnline,
    this.instructions,
    this.createdAt,
    this.updatedAt,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id: json['id'] as int? ?? 0,
      subjectId: json['subject_id'] as int? ?? 0,
      classroomId: json['classroom_id'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      maxScore: json['max_score'] as int? ?? 0,
      scheduledAt: json['scheduled_at']?.toString(),
      durationMinutes: json['duration_minutes'] as int? ?? 0,
      isOnline: json['is_online'] as bool? ?? false,
      instructions: json['instructions']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'subject_id': subjectId,
    'classroom_id': classroomId,
    'name': name,
    'type': type,
    'max_score': maxScore,
    'scheduled_at': scheduledAt,
    'duration_minutes': durationMinutes,
    'is_online': isOnline,
    'instructions': instructions,
  };

  @override
  List<Object?> get props => [id, name, subjectId, classroomId, scheduledAt];
}