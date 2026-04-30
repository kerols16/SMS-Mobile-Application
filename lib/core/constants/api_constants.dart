// lib/core/network/api_constants.dart

class ApiConstants {
  static const String baseUrl = 'https://helwalrabee.com';

  // Auth
  static const String authLogin  = '/api/auth/login';
  static const String authMe     = '/api/auth/me';
  static const String authLogout = '/api/auth/logout';

  // Users
  static const String users = '/api/users';
  static String userById(int id) => '/api/users/$id';

  // Students
  static const String students = '/api/students';
  static String studentById(int id) => '/api/students/$id';

  // Teachers
  static const String teachers = '/api/teachers';
  static String teacherById(int id) => '/api/teachers/$id';

  // Parents
  static const String parents = '/api/parents';
  static String parentById(int id) => '/api/parents/$id';

  // Files
  static const String fileUpload         = '/api/files/upload';
  static const String fileUploadMultiple = '/api/files/upload-multiple';
  static const String fileDelete         = '/api/files/delete';

  // Notifications
  static const String notifications            = '/api/notifications';
  static const String notificationsUnreadCount = '/api/notifications/unread-count';
  static const String notificationsMarkAllRead = '/api/notifications/mark-all-read';
  static String notificationById(int id)       => '/api/notifications/$id';
  static String notificationMarkRead(int id)   => '/api/notifications/$id/mark-read';
}

class StorageKeys {
  static const String token      = 'auth_token';
  static const String userData   = 'user_data';
  static const String isLoggedIn = 'is_logged_in';
  static const String userRole   = 'user_role';  
  static const String originalRole = 'original_role'; 

}

class StatusCodes {
  static const int success      = 200;
  static const int created      = 201;
  static const int badRequest   = 400;
  static const int unauthorized = 401;
  static const int forbidden    = 403;
  static const int notFound     = 404;
  static const int serverError  = 500;
}