import 'package:equatable/equatable.dart';

class StudentGradeModel extends Equatable {
  final int id;
  final int studentId;
  final int examId;
  final double? score;
  final double? totalMarks;
  final String? remarks;
  final String? examName;
  final String? subjectName;

  const StudentGradeModel({
    required this.id,
    required this.studentId,
    required this.examId,
    this.score,
    this.totalMarks,
    this.remarks,
    this.examName,
    this.subjectName,
  });

  factory StudentGradeModel.fromJson(Map<String, dynamic> json) {
    return StudentGradeModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      studentId: int.tryParse(json['student_id'].toString()) ?? 0,
      examId: int.tryParse(json['exam_id'].toString()) ?? 0,
      score: json['score'] != null
          ? double.tryParse(json['score'].toString())
          : null,
      totalMarks: json['exam']?['max_score'] != null
          ? double.tryParse(json['exam']['max_score'].toString())
          : null,
      remarks: json['remarks']?.toString(),
      examName: json['exam']?['name']?.toString(),
      subjectName: json['exam']?['subject']?['name']?.toString(),
    );
  }

  @override
  List<Object?> get props => [id, examId, score];
}