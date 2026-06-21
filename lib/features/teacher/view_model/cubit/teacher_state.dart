part of 'teacher_cubit.dart';

abstract class TeacherState extends Equatable {
  const TeacherState();
  @override
  List<Object?> get props => [];
}

class TeacherInitial extends TeacherState {}

class TeacherLoading extends TeacherState {}

class TeacherError extends TeacherState {
  final String message;
  const TeacherError(this.message);
  @override
  List<Object?> get props => [message];
}

class TeacherLoaded extends TeacherState {
  final List<TeacherClassroomModel> classrooms;
  final List<TeacherStudentModel> students;
  final List<TeacherMessageModel> messages;
  final List<TeacherAssignmentModel> assignments;
  final List<TeacherExamModel> exams;
  final List<TeacherGradeModel> grades;
  final List<TeacherAttendanceModel> attendances;
  final List<TeacherSubmissionModel> submissions;
  final List<TeacherResourceModel> resources;
  final List<TeacherNotificationModel> notifications;
  final int unreadMessageCount;
  final int unreadNotificationCount;
  final int totalStudents;
  final int teacherUserId;
  final String teacherName;
  final String teacherRole;

  const TeacherLoaded({
    this.classrooms = const [],
    this.students = const [],
    this.messages = const [],
    this.assignments = const [],
    this.exams = const [],
    this.grades = const [],
    this.attendances = const [],
    this.submissions = const [],
    this.resources = const [],
    this.notifications = const [],
    this.unreadMessageCount = 0,
    this.unreadNotificationCount = 0,
    this.totalStudents = 0,
    this.teacherUserId = 0,
    this.teacherName = '',
    this.teacherRole = '',
  });

  @override
  List<Object?> get props => [
    classrooms,
    students,
    messages,
    assignments,
    exams,
    grades,
    attendances,
    submissions,
    resources,
    notifications,
    unreadMessageCount,
    unreadNotificationCount,
    totalStudents,
    teacherUserId,
    teacherName,
    teacherRole,
  ];

  TeacherLoaded copyWith({
    List<TeacherClassroomModel>? classrooms,
    List<TeacherStudentModel>? students,
    List<TeacherMessageModel>? messages,
    List<TeacherAssignmentModel>? assignments,
    List<TeacherExamModel>? exams,
    List<TeacherGradeModel>? grades,
    List<TeacherAttendanceModel>? attendances,
    List<TeacherSubmissionModel>? submissions,
    List<TeacherResourceModel>? resources,
    List<TeacherNotificationModel>? notifications,
    int? unreadMessageCount,
    int? unreadNotificationCount,
    int? totalStudents,
    int? teacherUserId,
    String? teacherName,
    String? teacherRole,
  }) {
    return TeacherLoaded(
      classrooms: classrooms ?? this.classrooms,
      students: students ?? this.students,
      messages: messages ?? this.messages,
      assignments: assignments ?? this.assignments,
      exams: exams ?? this.exams,
      grades: grades ?? this.grades,
      attendances: attendances ?? this.attendances,
      submissions: submissions ?? this.submissions,
      resources: resources ?? this.resources,
      notifications: notifications ?? this.notifications,
      unreadMessageCount: unreadMessageCount ?? this.unreadMessageCount,
      unreadNotificationCount: unreadNotificationCount ?? this.unreadNotificationCount,
      totalStudents: totalStudents ?? this.totalStudents,
      teacherUserId: teacherUserId ?? this.teacherUserId,
      teacherName: teacherName ?? this.teacherName,
      teacherRole: teacherRole ?? this.teacherRole,
    );
  }
}

class TeacherOperationLoading extends TeacherState {}

class TeacherOperationSuccess extends TeacherState {
  final String message;
  const TeacherOperationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class TeacherOperationError extends TeacherState {
  final String message;
  const TeacherOperationError(this.message);
  @override
  List<Object?> get props => [message];
}