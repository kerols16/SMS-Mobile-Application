import 'package:equatable/equatable.dart';

class AttendanceModel extends Equatable {
  final int id;
  final int studentId;
  final int classroomId;
  final String date;          // YYYY-MM-DD
  final String status;        // present, absent, late, excused
  final String? notes;
  final String? createdAt;
  final String? updatedAt;

  const AttendanceModel({
    required this.id,
    required this.studentId,
    required this.classroomId,
    required this.date,
    required this.status,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'] as int,
      studentId: json['student_id'] as int,
      classroomId: json['classroom_id'] as int,
      date: json['date'] as String,
      status: json['status'] as String,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'classroom_id': classroomId,
      'date': date,
      'status': status,
      'notes': notes,
    };
  }

  @override
  List<Object?> get props => [id, studentId, classroomId, date, status, notes];
}