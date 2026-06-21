class Routes {
  static String login = "/";
  static String admin = "/admin";
  static String superAdmin = "/super_admin";
  static String student = "/student";
  static String teacher = "/teacher";
  static String parent = "/parent";
   
  // ── Admin sub-routes ──────────────────────────────────────────
  static String adminClassroom(Object id) => 'classroom/$id';
  static String adminSubject(Object id)   => 'subject/$id';
  static String adminSchedule(Object id)  => 'schedule/$id';
  static String adminUser(Object id)      => 'user/$id';
}
