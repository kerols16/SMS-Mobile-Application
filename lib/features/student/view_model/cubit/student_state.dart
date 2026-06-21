part of 'student_cubit.dart';

abstract class StudentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class StudentInitial extends StudentState {}

class StudentLoading extends StudentState {}

class StudentError extends StudentState {
  final String message;
  StudentError(this.message);
  @override List<Object?> get props => [message];
}

// ─── Loaded State ──────────────────────────────────────
class StudentLoaded extends StudentState {
  final StudentProfileModel profile;
  final StudentDashboardModel dashboard;
  final List<StudentScheduleModel> schedule;
  final List<StudentGradeModel> grades;
  final List<StudentExamModel> exams;
  final List<StudentSubjectModel> subjects;
  final StudentClassroomModel classroom;
  final List<StudentTeacherModel> teachers;
  final List<StudentAssignmentModel> assignments;
  final List<StudentSubmissionModel> submissions;
  final List<StudentAttendanceModel> attendances;
  final StudentAttendanceSummaryModel attendanceSummary;
  final List<StudentResourceModel> resources;

  StudentLoaded({
    required this.profile,
    required this.dashboard,
    this.schedule = const [],
    this.grades = const [],
    this.exams = const [],
    this.subjects = const [],
    required this.classroom,
    this.teachers = const [],
    this.assignments = const [],
    this.submissions = const [],
    this.attendances = const [],
    required this.attendanceSummary,
    this.resources = const [],
  });

  @override
  List<Object?> get props => [
        profile,
        dashboard,
        schedule,
        grades,
        exams,
        subjects,
        classroom,
        teachers,
        assignments,
        submissions,
        attendances,
        attendanceSummary,
        resources,
      ];

  StudentLoaded copyWith({
    StudentProfileModel? profile,
    StudentDashboardModel? dashboard,
    List<StudentScheduleModel>? schedule,
    List<StudentGradeModel>? grades,
    List<StudentExamModel>? exams,
    List<StudentSubjectModel>? subjects,
    StudentClassroomModel? classroom,
    List<StudentTeacherModel>? teachers,
    List<StudentAssignmentModel>? assignments,
    List<StudentSubmissionModel>? submissions,
    List<StudentAttendanceModel>? attendances,
    StudentAttendanceSummaryModel? attendanceSummary,
    List<StudentResourceModel>? resources,
  }) {
    return StudentLoaded(
      profile: profile ?? this.profile,
      dashboard: dashboard ?? this.dashboard,
      schedule: schedule ?? this.schedule,
      grades: grades ?? this.grades,
      exams: exams ?? this.exams,
      subjects: subjects ?? this.subjects,
      classroom: classroom ?? this.classroom,
      teachers: teachers ?? this.teachers,
      assignments: assignments ?? this.assignments,
      submissions: submissions ?? this.submissions,
      attendances: attendances ?? this.attendances,
      attendanceSummary: attendanceSummary ?? this.attendanceSummary,
      resources: resources ?? this.resources,
    );
  }
}

// ─── Operation States ──────────────────────────────────
class StudentOperationLoading extends StudentState {}

class StudentOperationSuccess extends StudentState {
  final String message;
  StudentOperationSuccess(this.message);
  @override List<Object?> get props => [message];
}

class StudentOperationError extends StudentState {
  final String message;
  StudentOperationError(this.message);
  @override List<Object?> get props => [message];
}