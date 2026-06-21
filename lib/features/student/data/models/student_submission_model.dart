import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class StudentSubmissionModel extends Equatable {
  final int id;
  final int assignmentId;
  final int studentId;
  final String? content;
  final String? filePath;
  final double? score;
  final String? feedback;
  final String submittedAt;
  final String? gradedAt;
  final String? assignmentTitle;

  const StudentSubmissionModel({
    required this.id,
    required this.assignmentId,
    required this.studentId,
    this.content,
    this.filePath,
    this.score,
    this.feedback,
    required this.submittedAt,
    this.gradedAt,
    this.assignmentTitle,
  });

  factory StudentSubmissionModel.fromJson(Map<String, dynamic> json) {
    debugPrint('📄 Submission JSON: $json');

    double? parseScore(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      if (value is String) {
        final parsed = double.tryParse(value);
        debugPrint('📄 Parsed score from String: $parsed');
        return parsed;
      }
      debugPrint('⚠️ Unknown score type: ${value.runtimeType}');
      return null;
    }

    return StudentSubmissionModel(
      id: json['id'] as int? ?? 0,
      assignmentId: json['assignment_id'] as int? ?? 0,
      studentId: json['student_id'] as int? ?? 0,
      content: json['content'] as String?,
      filePath: json['file_path'] as String?,
      score: parseScore(json['score']),
      feedback: json['feedback'] as String?,
      submittedAt: json['submitted_at'] as String? ?? '',
      gradedAt: json['graded_at'] as String?,
      assignmentTitle: json['assignment']?['title'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, assignmentId, submittedAt];
}