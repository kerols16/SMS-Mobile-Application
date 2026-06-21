import 'package:equatable/equatable.dart';

// ---- نموذج سجل الحضور الفردي ----
class StudentAttendanceModel extends Equatable {
  final int id;
  final int studentId;
  final int classroomId;
  final String date;
  final String status;
  final String? notes;
  final String? classroomName;

  const StudentAttendanceModel({
    required this.id,
    required this.studentId,
    required this.classroomId,
    required this.date,
    required this.status,
    this.notes,
    this.classroomName,
  });

  factory StudentAttendanceModel.fromJson(Map<String, dynamic> json) {
    return StudentAttendanceModel(
      id: json['id'] as int? ?? 0,
      studentId: json['student_id'] as int? ?? 0,
      classroomId: json['classroom_id'] as int? ?? 0,
      date: json['date'] as String? ?? '',
      status: json['status'] as String? ?? '',
      notes: json['notes'] as String?,
      classroomName: json['classroom']?['name'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, date, status];
}

class StudentAttendanceSummaryModel extends Equatable {
  final int totalRecords;
  final Map<String, int> byStatus;
  final double attendanceRate;

  const StudentAttendanceSummaryModel({
    required this.totalRecords,
    required this.byStatus,
    required this.attendanceRate,
  });

  factory StudentAttendanceSummaryModel.fromJson(Map<String, dynamic> json) {
    // قراءة attendance_rate بشكل آمن من String أو num
    double parseRate(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return StudentAttendanceSummaryModel(
      totalRecords: json['total_records'] as int? ?? 0,
      byStatus: (json['by_status'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, v as int)) ??
          {},
      attendanceRate: parseRate(json['attendance_rate']),
    );
  }

  @override
  List<Object?> get props => [totalRecords, byStatus, attendanceRate];
}