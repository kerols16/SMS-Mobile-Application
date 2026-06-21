import 'package:equatable/equatable.dart';

class TeacherSubmissionModel extends Equatable {
  final int id;
  final int assignmentId;
  final int studentId;
  final String? studentName;
  final String? content;
  final String? filePath;
  final String? submittedAt;
  final int? score;
  final String? feedback;
  final int? gradedBy;
  final String? gradedAt;

  const TeacherSubmissionModel({
    required this.id,
    required this.assignmentId,
    required this.studentId,
    this.studentName,
    this.content,
    this.filePath,
    this.submittedAt,
    this.score,
    this.feedback,
    this.gradedBy,
    this.gradedAt,
  });

  bool get isGraded => gradedAt != null;

  factory TeacherSubmissionModel.fromJson(Map<String, dynamic> json) {
    return TeacherSubmissionModel(
      id: json['id'] as int,
      assignmentId: json['assignment_id'] as int? ?? 0,
      studentId: json['student_id'] as int? ?? 0,
      studentName: (json['student'] as Map<String, dynamic>?)?['name'] as String?
          ?? json['student_name'] as String?,
      content: json['content'] as String?,
      filePath: json['file_path'] as String?,
      submittedAt: json['submitted_at'] as String?,
      score: json['score'] as int?,
      feedback: json['feedback'] as String?,
      gradedBy: json['graded_by'] as int?,
      gradedAt: json['graded_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'assignment_id': assignmentId,
    'student_id': studentId,
    'student_name': studentName,
    'content': content,
    'file_path': filePath,
    'submitted_at': submittedAt,
    'score': score,
    'feedback': feedback,
    'graded_by': gradedBy,
    'graded_at': gradedAt,
  };

  @override
  List<Object?> get props => [
    id, assignmentId, studentId, studentName, content,
    filePath, submittedAt, score, feedback, gradedBy, gradedAt,
  ];
}