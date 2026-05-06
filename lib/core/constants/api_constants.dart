// lib/core/network/api_constants.dart

class ApiConstants {
  static const String baseUrl = 'https://helwalrabee.com';

  // =========================
  // Auth
  // =========================
  static const String authLogin  = '/api/auth/login';
  static const String authMe     = '/api/auth/me';
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
  static const String myStudents   = '/api/teachers/me/students';
  static String teacherClassrooms(int id) => '/api/teachers/$id/classrooms';
  static String teacherStudents(int id)   => '/api/teachers/$id/students';

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
  static String submitAssignment(int id) =>
      '/api/assignments/$id/submit';

  // =========================
  // Submissions
  // =========================
  static const String submissions = '/api/submissions';
  static String submissionById(int id) => '/api/submissions/$id';
  static String gradeSubmission(int id) =>
      '/api/submissions/$id/grade';

  // =========================
  // Files
  // =========================
  static const String fileUpload         = '/api/files/upload';
  static const String fileUploadMultiple = '/api/files/upload-multiple';
  static const String fileDelete         = '/api/files/delete';

  // =========================
  // Notifications
  // =========================
  static const String notifications            = '/api/notifications';
  static const String notificationsUnreadCount = '/api/notifications/unread-count';
  static const String notificationsMarkAllRead = '/api/notifications/mark-all-read';
  static String notificationById(int id)       => '/api/notifications/$id';
  static String notificationMarkRead(int id)   =>
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

  // =========================
  // Misc
  // =========================
  static const String test = '/api/user';
}


// =========================
// Storage Keys
// =========================
class StorageKeys {
  static const String token        = 'auth_token';
  static const String userData     = 'user_data';
  static const String isLoggedIn   = 'is_logged_in';
  static const String userRole     = 'user_role';
  static const String originalRole = 'original_role';
}


// =========================
// Status Codes
// =========================
class StatusCodes {
  static const int success      = 200;
  static const int created      = 201;
  static const int badRequest   = 400;
  static const int unauthorized = 401;
  static const int forbidden    = 403;
  static const int notFound     = 404;
  static const int serverError  = 500;
}