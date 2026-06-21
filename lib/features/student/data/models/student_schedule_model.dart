import 'package:equatable/equatable.dart';

class StudentScheduleModel extends Equatable {
  final int id;
  final int classroomId;
  final int subjectId;
  final int teacherId;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final String? roomNumber;
  final String? subjectName;
  final String? teacherName;

  const StudentScheduleModel({
    required this.id,
    required this.classroomId,
    required this.subjectId,
    required this.teacherId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.roomNumber,
    this.subjectName,
    this.teacherName,
  });

  factory StudentScheduleModel.fromJson(Map<String, dynamic> json) {
    return StudentScheduleModel(
      id: json['id'] as int? ?? 0,
      classroomId: json['classroom_id'] as int? ?? 0,
      subjectId: json['subject_id'] as int? ?? 0,
      teacherId: json['teacher_id'] as int? ?? 0,
      dayOfWeek: json['day_of_week'] as String? ?? '',
      startTime: json['start_time'] as String? ?? '',
      endTime: json['end_time'] as String? ?? '',
      roomNumber: json['room_number'] as String?,
      subjectName: json['subject']?['name'] as String?,
      teacherName: json['teacher']?['user']?['name'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, dayOfWeek, startTime, endTime];
}