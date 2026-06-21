import 'package:equatable/equatable.dart';
import 'student_teacher_model.dart';

class StudentSubjectModel extends Equatable {
  final int id;
  final String name;
  final String code;
  final String? description;
  final int credits;
  final String? type;
  final List<StudentTeacherModel> teachers;

  const StudentSubjectModel({
    required this.id,
    required this.name,
    required this.code,
    this.description,
    required this.credits,
    this.type,
    this.teachers = const [],
  });

  factory StudentSubjectModel.fromJson(Map<String, dynamic> json) {
    final teachersData = json['teachers'] as List? ?? [];
    return StudentSubjectModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
      description: json['description'] as String?,
      credits: json['credits'] as int? ?? 0,
      type: json['type'] as String?,
      teachers: teachersData.map((e) => StudentTeacherModel.fromJson(e)).toList(),
    );
  }

  @override
  List<Object?> get props => [id, name, code];
}