// ═══ FILE: lib/features/teacher/data/models/teacher_student_model.dart ═══
import 'package:equatable/equatable.dart';

class TeacherStudentModel extends Equatable {
  final int id;
  final int userId;
  final String studentId;
  final String name;
  final String email;

  const TeacherStudentModel({
    required this.id,
    required this.userId,
    required this.studentId,
    required this.name,
    required this.email,
  });

  factory TeacherStudentModel.fromJson(Map<String, dynamic> json) {
  final user = json['user'] as Map<String, dynamic>? ?? {};
  return TeacherStudentModel(
    id: json['id'] as int,
    userId: json['user_id'] as int? ?? 0,
    studentId: json['student_id'] as String? ?? '',
    name: user['name'] as String? ?? 'Unknown',
    email: user['email'] as String? ?? '',
  );

  }

  @override
  List<Object?> get props => [id, userId, studentId, name, email];
}