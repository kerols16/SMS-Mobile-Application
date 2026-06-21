import 'package:equatable/equatable.dart';
import 'student_subject_model.dart';
import 'student_teacher_model.dart';

class StudentClassroomModel extends Equatable {
  final int id;
  final String name;
  final String gradeLevel;
  final int capacity;
  final String academicYear;
  final List<StudentSubjectModel> subjects;
  final List<StudentTeacherModel> teachers;

  const StudentClassroomModel({
    required this.id,
    required this.name,
    required this.gradeLevel,
    required this.capacity,
    required this.academicYear,
    this.subjects = const [],
    this.teachers = const [],
  });

  factory StudentClassroomModel.fromJson(Map<String, dynamic> json) {
    final subjectsData = json['subjects'] as List? ?? [];
    final teachersData = json['teachers'] as List? ?? [];

    return StudentClassroomModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      gradeLevel: json['grade_level'] as String? ?? '',
      capacity: json['capacity'] as int? ?? 0,
      academicYear: json['academic_year'] as String? ?? '',
      subjects: subjectsData.map((e) => StudentSubjectModel.fromJson(e)).toList(),
      teachers: teachersData.map((e) => StudentTeacherModel.fromJson(e)).toList(),
    );
  }

  @override
  List<Object?> get props => [id, name, subjects, teachers];
}

class StudentClassmateModel extends Equatable {
  final int id;
  final String name;
  final String? email;

  const StudentClassmateModel({
    required this.id,
    required this.name,
    this.email,
  });

  factory StudentClassmateModel.fromJson(Map<String, dynamic> json) {
    return StudentClassmateModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Unknown',
      email: json['email'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, name];
}