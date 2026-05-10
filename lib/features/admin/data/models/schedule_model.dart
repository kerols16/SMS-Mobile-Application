class ScheduleModel {
  final int id;
  final int classroomId;
  final int subjectId;
  final int teacherId;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final String roomNumber;
  final String semester;
  final String academicYear;
  final bool isActive;
  final Map<String, dynamic>? classroom;
  final Map<String, dynamic>? subject;
  final Map<String, dynamic>? teacher;

  ScheduleModel({
    required this.id,
    required this.classroomId,
    required this.subjectId,
    required this.teacherId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.roomNumber,
    required this.semester,
    required this.academicYear,
    required this.isActive,
    this.classroom,
    this.subject,
    this.teacher,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) => ScheduleModel(
    id: json['id'] ?? 0,
    classroomId: json['classroom_id'] ?? 0,
    subjectId: json['subject_id'] ?? 0,
    teacherId: json['teacher_id'] ?? 0,
    dayOfWeek: json['day_of_week'] ?? '',
    startTime: json['start_time'] ?? '',
    endTime: json['end_time'] ?? '',
    roomNumber: json['room_number'] ?? '',
    semester: json['semester'] ?? '',
    academicYear: json['academic_year'] ?? '',
    isActive: json['is_active'] ?? false,
    classroom: json['classroom'],
    subject: json['subject'],
    teacher: json['teacher'],
  );
}