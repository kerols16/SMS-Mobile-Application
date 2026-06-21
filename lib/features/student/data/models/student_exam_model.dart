import 'package:equatable/equatable.dart';

class StudentExamModel extends Equatable {
  final int id;
  final String name;
  final int subjectId;
  final int classroomId;
  final String? scheduledAt;
  final int durationMinutes;
  final int maxScore;
  final String? subjectName;

  const StudentExamModel({
    required this.id,
    required this.name,
    required this.subjectId,
    required this.classroomId,
    this.scheduledAt,
    required this.durationMinutes,
    required this.maxScore,
    this.subjectName,
  });

  factory StudentExamModel.fromJson(Map<String, dynamic> json) {
    return StudentExamModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      subjectId: json['subject_id'] as int? ?? 0,
      classroomId: json['classroom_id'] as int? ?? 0,
      scheduledAt: json['scheduled_at'] as String?,
      durationMinutes: json['duration_minutes'] as int? ?? 0,
      maxScore: json['max_score'] as int? ?? 0,
      subjectName: json['subject']?['name'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, name, scheduledAt];

  String get title => name;

  String get countdownLabel {
    if (scheduledAt == null) return 'No date set';

    return scheduledAt!;
  }
}
