// teacher_grade_model.dart
class TeacherGradeModel {
  final int id;
  final int? studentId;
  final int? examId;
  final double? score;        
  final String? grade;
  final String? remarks;
  final String? studentName;
  final String? examName;

  TeacherGradeModel({
    required this.id,
    this.studentId,
    this.examId,
    this.score,
    this.grade,
    this.remarks,
    this.studentName,
    this.examName,
  });

  factory TeacherGradeModel.fromJson(Map<String, dynamic> json) {
    return TeacherGradeModel(
      id: json['id'] as int,
      studentId: _parseInt(json['student_id']),
      examId: _parseInt(json['exam_id']),
      score: _parseDouble(json['score']),
      grade: json['grade'] as String?,
      remarks: json['remarks'] as String?,
      studentName: json['student_name'] as String?,
      examName: json['exam_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'student_id': studentId,
    'exam_id': examId,
    'score': score,
    'grade': grade,
    'remarks': remarks,
    'student_name': studentName,
    'exam_name': examName,
  };

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is double) return value.toInt();
    return null;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}