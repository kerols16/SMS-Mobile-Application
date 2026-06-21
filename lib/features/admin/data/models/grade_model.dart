import 'package:school_test/features/admin/data/models/admin_student_model.dart';
import 'package:school_test/features/admin/data/models/exam_model.dart';

class GradeModel {
  final int id;
  final int examId;
  final int studentId;
  final double? score; // <-- بدل int?
  final String? gradeLetter;
  final String? remarks;
  final int? gradedBy;
  final String? createdAt;
  final String? updatedAt;

  final AdminStudentModel? student;
  final ExamModel? exam;
  final AdminStudentModel? grader;

  GradeModel({
    required this.id,
    required this.examId,
    required this.studentId,
    this.score,
    this.gradeLetter,
    this.remarks,
    this.gradedBy,
    this.createdAt,
    this.updatedAt,
    this.student,
    this.exam,
    this.grader,
  });

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;

    return GradeModel(
      id: data['id'] ?? 0,
      examId: data['exam_id'] ?? 0,
      studentId: data['student_id'] ?? 0,

      score: data['score'] != null
          ? double.tryParse(data['score'].toString())
          : null,

      gradeLetter: data['grade'],
      remarks: data['remarks'],
      gradedBy: data['graded_by'],
      createdAt: data['created_at'],
      updatedAt: data['updated_at'],

      student: data['student'] != null
          ? AdminStudentModel.fromJson(data['student'])
          : null,

      exam: data['exam'] != null
          ? ExamModel.fromJson(data['exam'])
          : null,

      grader: data['grader'] != null
          ? AdminStudentModel.fromJson(data['grader'])
          : null,
    );
  }
}