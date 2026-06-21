// lib/features/teacher/data/models/teacher_schedule_model.dart

class TeacherScheduleEntry {
  final int id;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final String roomNumber;
  final String subjectName;
  final String classroomName;

  TeacherScheduleEntry({
    required this.id,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.roomNumber,
    required this.subjectName,
    required this.classroomName,
  });

  factory TeacherScheduleEntry.fromJson(Map<String, dynamic> json) {
    return TeacherScheduleEntry(
      id: json['id'] as int,
      dayOfWeek: json['day_of_week'] as String? ?? '',
      startTime: json['start_time'] as String? ?? '',
      endTime: json['end_time'] as String? ?? '',
      roomNumber: json['room_number'] as String? ?? '',
      subjectName: json['subject']?['name'] as String? ?? '',
      classroomName: json['classroom']?['name'] as String? ?? '',
    );
  }
}