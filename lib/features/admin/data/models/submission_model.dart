import 'package:equatable/equatable.dart';

class SubmissionModel extends Equatable {
  final int id;
  final int assignmentId;
  final int studentId;
  final String? filePath;       // path to submitted file
  final String? notes;          // optional notes from student
  final double? marksObtained;  // set by teacher during grading
  final String? feedback;       // teacher feedback
  final String submittedAt;
  final String? gradedAt;
  final String? createdAt;
  final String? updatedAt;

  const SubmissionModel({
    required this.id,
    required this.assignmentId,
    required this.studentId,
    this.filePath,
    this.notes,
    this.marksObtained,
    this.feedback,
    required this.submittedAt,
    this.gradedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory SubmissionModel.fromJson(Map<String, dynamic> json) {
    return SubmissionModel(
      id: json['id'] as int,
      assignmentId: json['assignment_id'] as int,
      studentId: json['student_id'] as int,
      filePath: json['file_path'] as String?,
      notes: json['notes'] as String?,
      marksObtained: (json['marks_obtained'] as num?)?.toDouble(),
      feedback: json['feedback'] as String?,
      submittedAt: json['submitted_at'] as String,
      gradedAt: json['graded_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assignment_id': assignmentId,
      'student_id': studentId,
      'file_path': filePath,
      'notes': notes,
      'marks_obtained': marksObtained,
      'feedback': feedback,
      'submitted_at': submittedAt,
      'graded_at': gradedAt,
    };
  }

  @override
  List<Object?> get props => [
    id, assignmentId, studentId, filePath, notes,
    marksObtained, feedback, submittedAt, gradedAt
  ];
}