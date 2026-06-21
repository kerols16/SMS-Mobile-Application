// lib/core/network/api_constants.dart

class ApiConstants {
  static const String baseUrl = 'https://helwalrabee.com';

  // =========================
  // Auth
  // =========================
  static const String authLogin = '/api/auth/login';
  static const String authMe = '/api/auth/me';
  static const String authLogout = '/api/auth/logout';

  // =========================
  // Users
  // =========================
  static const String users = '/api/users';
  static String userById(int id) => '/api/users/$id';

  // =========================
  // Students
  // =========================
  static const String students = '/api/students';
  static String studentById(int id) => '/api/students/$id';

  // =========================
  // Teachers
  // =========================
  static const String teachers = '/api/teachers';
  static String teacherById(int id) => '/api/teachers/$id';

  // Teacher special
  static const String myClassrooms = '/api/teachers/me/classrooms';
  static const String myStudents = '/api/teachers/me/students';
  static String teacherClassrooms(int id) => '/api/teachers/$id/classrooms';
  static String teacherStudents(int id) => '/api/teachers/$id/students';

  // =========================
  // Parents
  // =========================
  static const String parents = '/api/parents';
  static String parentById(int id) => '/api/parents/$id';

  // =========================
  // Classrooms
  // =========================
  static const String classrooms = '/api/classrooms';
  static String classroomById(int id) => '/api/classrooms/$id';

  // =========================
  // Subjects
  // =========================
  static const String subjects = '/api/subjects';
  static String subjectById(int id) => '/api/subjects/$id';

  // =========================
  // Schedules
  // =========================
  static const String schedules = '/api/schedules';
  static String scheduleById(int id) => '/api/schedules/$id';

  // =========================
  // Attendances
  // =========================
  static const String attendances = '/api/attendances';
  static String attendanceById(int id) => '/api/attendances/$id';

  // =========================
  // Exams
  // =========================
  static const String exams = '/api/exams';
  static String examById(int id) => '/api/exams/$id';

  // =========================
  // Grades
  // =========================
  static const String grades = '/api/grades';
  static String gradeById(int id) => '/api/grades/$id';

  // =========================
  // Assignments
  // =========================
  static const String assignments = '/api/assignments';
  static String assignmentById(int id) => '/api/assignments/$id';

  // Assignment submission
  static String submitAssignment(int id) => '/api/assignments/$id/submit';

  // =========================
  // Submissions
  // =========================
  static const String submissions = '/api/submissions';
  static String submissionById(int id) => '/api/submissions/$id';
  static String gradeSubmission(int id) => '/api/submissions/$id/grade';

  // =========================
  // Files
  // =========================
  static const String fileUpload = '/api/files/upload';
  static const String fileUploadMultiple = '/api/files/upload-multiple';
  static const String fileDelete = '/api/files/delete';

  // =========================
  // Notifications
  // =========================
  static const String notifications = '/api/notifications';
  static const String notificationsUnreadCount =
      '/api/notifications/unread-count';
  static const String notificationsMarkAllRead =
      '/api/notifications/mark-all-read';
  static String notificationById(int id) => '/api/notifications/$id';
  static String notificationMarkRead(int id) =>
      '/api/notifications/$id/mark-read';

  // =========================
  // Classroom Relationships
  // =========================
  static const String enrollStudent =
      '/api/classroom-relationships/enroll-student';

  static const String removeStudent =
      '/api/classroom-relationships/remove-student';

  static const String updateStudentStatus =
      '/api/classroom-relationships/update-student-status';

  static const String assignTeacher =
      '/api/classroom-relationships/assign-teacher';

  static const String removeTeacher =
      '/api/classroom-relationships/remove-teacher';

  static const String updateTeacherRole =
      '/api/classroom-relationships/update-teacher-role';

  static const String assignSubject =
      '/api/classroom-relationships/assign-subject';

  static const String removeSubject =
      '/api/classroom-relationships/remove-subject';

  static const String changeSubjectTeacher =
      '/api/classroom-relationships/change-subject-teacher';

  static const String updateSubjectHours =
      '/api/classroom-relationships/update-subject-hours';

  static String classroomRelationships(int id) =>
      '/api/classroom-relationships/classroom/$id';

  // Messages
  static const String messages = '/api/messages';
  static const String messagesUnreadCount = '/api/messages/unread-count';
  static const String messagesAvailableParents =
      '/api/messages/available-parents';
  static String messageById(int id) => '/api/messages/$id';

  // Resources
  static const String resources = '/api/resources';
  static const String resourcesMy = '/api/resources/my';
  static const String resourcesPopular = '/api/resources/popular';
  static String resourceDownload(int id) => '/api/resources/$id/download';
  static String resourceById(int id) => '/api/resources/$id';


  // =========================
  // Student Portal (NEW)
  // =========================
  static const String studentProfile = '/api/student/profile';
  static const String studentDashboard = '/api/student/dashboard';
  static const String studentSchedule = '/api/student/schedule';
  static const String studentGrades = '/api/student/grades';
  static const String studentExams = '/api/student/exams';
  static const String studentSubjects = '/api/student/subjects';
  static const String studentClassroom = '/api/student/classroom';
  static const String studentTeachers = '/api/student/teachers';
  static const String studentAssignments = '/api/student/assignments';
  static String studentAssignmentById(int id) => '/api/student/assignments/$id';
  static String studentSubmitAssignment(int id) => '/api/student/assignments/$id/submit';
  static const String studentSubmissions = '/api/student/submissions';
  static const String studentAttendance = '/api/student/attendance';
  static const String studentAttendanceSummary = '/api/student/attendance/summary';
  static const String studentResources = '/api/student/resources';


  // =========================
// Teacher Portal (NEW)
// =========================
static const String teacherProfile = '/api/teacher/profile';
static const String apiTeacherClassrooms = '/api/teacher/classrooms';
static String teacherClassroomById(int id) => '/api/teacher/classrooms/$id';
static const String apiTeacherStudents = '/api/teacher/students';
static String teacherStudentById(int id) => '/api/teacher/students/$id';
static const String teacherAssignments = '/api/teacher/assignments';
static String teacherAssignmentById(int id) => '/api/teacher/assignments/$id';
static String teacherAssignmentSubmissions(int id) => '/api/teacher/assignments/$id/submissions';
static const String teacherSubmissions = '/api/teacher/submissions';
static String teacherSubmissionById(int id) => '/api/teacher/submissions/$id';
static String teacherGradeSubmission(int id) => '/api/teacher/submissions/$id/grade';
static const String teacherGrades = '/api/teacher/grades';
static String teacherGradeById(int id) => '/api/teacher/grades/$id';
static String teacherStudentGrades(int id) => '/api/teacher/grades/student/$id';
static const String teacherAttendance = '/api/teacher/attendance';
static String teacherAttendanceById(int id) => '/api/teacher/attendance/$id';
static String teacherClassroomAttendanceSummary(int id) => '/api/teacher/attendance/classroom/$id/summary';
static String teacherStudentAttendanceSummary(int id) => '/api/teacher/attendance/student/$id/summary';
static const String teacherExams = '/api/teacher/exams';
static String teacherExamById(int id) => '/api/teacher/exams/$id';
static String teacherExamResults(int id) => '/api/teacher/exams/$id/results';
static const String teacherMessages = '/api/teacher/messages';
static const String teacherMessagesAvailableParents = '/api/teacher/messages/parents/available';
static const String teacherMessagesUnreadCount = '/api/teacher/messages/count/unread';
static String teacherMessageById(int id) => '/api/teacher/messages/$id';
static const String teacherResources = '/api/teacher/resources';
static const String teacherResourcesMy = '/api/teacher/resources/my/list';
static const String teacherResourcesPopular = '/api/teacher/resources/popular/list';
static String teacherResourceById(int id) => '/api/teacher/resources/$id';
static String teacherResourceDownload(int id) => '/api/teacher/resources/$id/download';
static const String teacherNotifications = '/api/teacher/notifications';
static const String teacherNotificationsUnreadCount = '/api/teacher/notifications/count/unread';
static const String teacherNotificationsMarkAllRead = '/api/teacher/notifications/mark-all-read';
static String teacherNotificationById(int id) => '/api/teacher/notifications/$id';
static String teacherNotificationMarkRead(int id) => '/api/teacher/notifications/$id/mark-read';


  // =========================
  // Misc
  // =========================
  static const String test = '/api/user';
}

// =========================
// Storage Keys
// =========================
class StorageKeys {
  static const String token = 'auth_token';
  static const String userData = 'user_data';
  static const String isLoggedIn = 'is_logged_in';
  static const String userRole = 'user_role';
  static const String originalRole = 'original_role';
}

// =========================
// Status Codes
// =========================
class StatusCodes {
  static const int success = 200;
  static const int created = 201;
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int serverError = 500;
}
