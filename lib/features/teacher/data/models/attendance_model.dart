// ═══ FILE: lib/features/teacher/data/models/attendance_model.dart ═══
import 'package:equatable/equatable.dart';

class AttendanceModel extends Equatable {
  final int id;
  final int studentId;
  final int classroomId;
  final String date;
  final String status;
  final String? notes;
  final Map<String, dynamic>? student;
  final Map<String, dynamic>? classroom;

  const AttendanceModel({
    required this.id,
    required this.studentId,
    required this.classroomId,
    required this.date,
    required this.status,
    this.notes,
    this.student,
    this.classroom,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'] as int,
      studentId: json['student_id'] as int,
      classroomId: json['classroom_id'] as int,
      date: json['date'] as String,
      status: json['status'] as String,
      notes: json['notes'] as String?,
      student: json['student'] as Map<String, dynamic>?,
      classroom: json['classroom'] as Map<String, dynamic>?,
    );
  }

  String get studentName {
    if (student != null && student!['user'] != null) {
      return student!['user']['name'] as String? ?? 'Unknown';
    }
    return 'Unknown';
  }

  @override
  List<Object?> get props => [id, studentId, classroomId, date, status, notes];
}