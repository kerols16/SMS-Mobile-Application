part of 'admin_cubit.dart';

abstract class AdminState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminError extends AdminState {
  final String message;
  AdminError(this.message);

  @override
  List<Object?> get props => [message];
}

class AdminLoaded extends AdminState {
  final List<AdminUserModel> users;
  final List<AdminStudentModel> students;
  final List<AdminTeacherModel> teachers;
  final List<AdminParentModel> parents;
  final List<AdminNotificationModel> notifications;
  final List<ClassroomModel> classrooms;
  final List<SubjectModel> subjects;
  final List<ScheduleModel> schedules;
  final int unreadCount;
  final List<AttendanceModel> attendances;
  final List<ExamModel> exams;
  final List<GradeModel> grades;

  AdminLoaded({
    required this.users,
    required this.students,
    required this.teachers,
    required this.parents,
    required this.notifications,
    required this.unreadCount,
    required this.classrooms,
    required this.subjects,
    required this.schedules,
    this.attendances = const [],
    this.exams = const [],
    this.grades = const [],
  });

  AdminLoaded copyWith({
    List<AdminUserModel>? users,
    List<AdminStudentModel>? students,
    List<AdminTeacherModel>? teachers,
    List<AdminParentModel>? parents,
    List<AdminNotificationModel>? notifications,
    int? unreadCount,
    List<ClassroomModel>? classrooms,
    List<SubjectModel>? subjects,
    List<ScheduleModel>? schedules,
    List<AttendanceModel>? attendances,
    List<ExamModel>? exams,
    List<GradeModel>? grades,
  }) {
    return AdminLoaded(
      users: users ?? this.users,
      students: students ?? this.students,
      teachers: teachers ?? this.teachers,
      parents: parents ?? this.parents,
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      classrooms: classrooms ?? this.classrooms,
      subjects: subjects ?? this.subjects,
      schedules: schedules ?? this.schedules,
      attendances: attendances ?? this.attendances,
      exams: exams ?? this.exams,
      grades: grades ?? this.grades,
    );
  }
} 
// operation states — for create / update / delete
class AdminOperationLoading extends AdminState {}

class AdminOperationSuccess extends AdminState {
  final String message;
  AdminOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AdminOperationError extends AdminState {
  final String message;
  AdminOperationError(this.message);

  @override
  List<Object?> get props => [message];
}

// User Details States
class AdminUserDetailsLoading extends AdminState {}

class AdminUserDetailsLoaded extends AdminState {
  final AdminUserModel         user;
  final AdminStudentModel?     student;
  final AdminTeacherModel?     teacher;
  final AdminParentModel?      parent;

  AdminUserDetailsLoaded({
    required this.user,
    this.student,
    this.teacher,
    this.parent,
  });

  @override
  List<Object?> get props => [user, student, teacher, parent];
}

class AdminUserDetailsError extends AdminState {
  final String message;
  AdminUserDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}

class ClassroomLoaded extends AdminState {
  final ClassroomModel classroom;
  ClassroomLoaded(this.classroom);
}
class SubjectLoaded extends AdminState {
  final SubjectModel subject;
  SubjectLoaded(this.subject);
}

class ScheduleLoaded extends AdminState {
  final ScheduleModel schedule;
  ScheduleLoaded(this.schedule);
}

// Attendances
class AttendancesLoaded extends AdminState {
  final List<AttendanceModel> attendances;
  AttendancesLoaded(this.attendances);
  @override List<Object?> get props => [attendances];
}
class AttendanceLoaded extends AdminState {
  final AttendanceModel attendance;
  AttendanceLoaded(this.attendance);
  @override List<Object?> get props => [attendance];
}

// Exams
class ExamsLoaded extends AdminState {
  final List<ExamModel> exams;
  ExamsLoaded(this.exams);
  @override List<Object?> get props => [exams];
}
class ExamLoaded extends AdminState {
  final ExamModel exam;
  ExamLoaded(this.exam);
  @override List<Object?> get props => [exam];
}

// Grades
class GradesLoaded extends AdminState {
  final List<GradeModel> grades;
  GradesLoaded(this.grades);
  @override List<Object?> get props => [grades];
}
class GradeLoaded extends AdminState {
  final GradeModel grade;
  GradeLoaded(this.grade);
  @override List<Object?> get props => [grade];
}

// Assignments
class AssignmentsLoaded extends AdminState {
  final List<AssignmentModel> assignments;
  AssignmentsLoaded(this.assignments);
  @override List<Object?> get props => [assignments];
}
class AssignmentLoaded extends AdminState {
  final AssignmentModel assignment;
  AssignmentLoaded(this.assignment);
  @override List<Object?> get props => [assignment];
}

// Submissions
class SubmissionsLoaded extends AdminState {
  final List<SubmissionModel> submissions;
  SubmissionsLoaded(this.submissions);
  @override List<Object?> get props => [submissions];
}
class SubmissionLoaded extends AdminState {
  final SubmissionModel submission;
  SubmissionLoaded(this.submission);
  @override List<Object?> get props => [submission];
}

// Messages
class MessagesLoaded extends AdminState {
  final List<MessageModel> messages;
  MessagesLoaded(this.messages);
  @override List<Object?> get props => [messages];
}

// Resources
class ResourcesLoaded extends AdminState {
  final List<ResourceModel> resources;
  ResourcesLoaded(this.resources);
  @override List<Object?> get props => [resources];
}

// Teacher "me" endpoints
class TeacherClassroomsLoaded extends AdminState {
  final List<dynamic> classrooms;
  TeacherClassroomsLoaded(this.classrooms);
  @override List<Object?> get props => [classrooms];
}
class TeacherStudentsLoaded extends AdminState {
  final List<dynamic> students;
  TeacherStudentsLoaded(this.students);
  @override List<Object?> get props => [students];
}