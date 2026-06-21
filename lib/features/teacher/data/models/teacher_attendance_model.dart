import 'package:equatable/equatable.dart';

class TeacherAttendanceModel extends Equatable {
  final int id;
  final int studentId;
  final String? studentName;
  final int classroomId;
  final String? classroomName;
  final String date;
  final String status; // present | absent | late | excused
  final String? notes;
  final String? createdAt;

  const TeacherAttendanceModel({
    required this.id,
    required this.studentId,
    this.studentName,
    required this.classroomId,
    this.classroomName,
    required this.date,
    required this.status,
    this.notes,
    this.createdAt,
  });

  bool get isPresent => status == 'present';
  bool get isAbsent => status == 'absent';
  bool get isLate => status == 'late';
  bool get isExcused => status == 'excused';

  factory TeacherAttendanceModel.fromJson(Map<String, dynamic> json) {
    return TeacherAttendanceModel(
      id: json['id'] as int,
      studentId: json['student_id'] as int? ?? 0,
      studentName: (json['student'] as Map<String, dynamic>?)?['name'] as String?,
      classroomId: json['classroom_id'] as int? ?? 0,
      classroomName: (json['classroom'] as Map<String, dynamic>?)?['name'] as String?,
      date: json['date'] as String? ?? '',
      status: json['status'] as String? ?? 'present',
      notes: json['notes'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'student_id': studentId,
    'student_name': studentName,
    'classroom_id': classroomId,
    'classroom_name': classroomName,
    'date': date,
    'status': status,
    'notes': notes,
    'created_at': createdAt,
  };

  @override
  List<Object?> get props => [
    id, studentId, studentName, classroomId, classroomName,
    date, status, notes, createdAt,
  ];
}