import 'package:school_test/features/admin/data/models/subject_model.dart';
import 'package:school_test/features/admin/data/models/admin_teacher_model.dart';

class ClassroomModel {
  final int id;
  final String name;
  final String gradeLevel;     
  final int capacity;
  final String academicYear;
  final String? description;
  final bool isActive;
  final List<dynamic> students; 
  final List<dynamic> teachers; 
  final List<dynamic> subjects; 

  ClassroomModel({
    required this.id,
    required this.name,
    required this.gradeLevel,
    required this.capacity,
    required this.academicYear,
    this.description,
    required this.isActive,
    required this.students,
    required this.teachers,
    required this.subjects,
  });

  factory ClassroomModel.fromJson(Map<String, dynamic> json) => ClassroomModel(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    gradeLevel: json['grade_level'] ?? '',
    capacity: json['capacity'] ?? 0,
    academicYear: json['academic_year'] ?? '',
    description: json['description'],
    isActive: json['is_active'] ?? false,
    students: json['students'] ?? [],
    teachers: json['teachers'] ?? [],
    subjects: json['subjects'] ?? [],
  );
}