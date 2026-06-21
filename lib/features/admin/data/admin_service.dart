// lib/features/admin/data/admin_service.dart
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:school_test/features/admin/data/models/notification_model.dart';
import 'package:school_test/features/admin/data/models/admin_parent_model.dart';
import 'package:school_test/features/admin/data/models/admin_student_model.dart';
import 'package:school_test/features/admin/data/models/admin_teacher_model.dart';
import 'package:school_test/features/admin/data/models/admin_user_model.dart';
import 'package:school_test/features/admin/data/models/classroom_model.dart';
import 'package:school_test/features/admin/data/models/subject_model.dart';
import 'package:school_test/features/admin/data/models/schedule_model.dart';
import 'package:school_test/features/admin/data/models/attendance_model.dart';
import 'package:school_test/features/admin/data/models/exam_model.dart';
import 'package:school_test/features/admin/data/models/grade_model.dart';
import 'package:school_test/features/admin/data/models/assignment_model.dart';
import 'package:school_test/features/admin/data/models/submission_model.dart';
import 'package:school_test/features/admin/data/models/message_model.dart';
import 'package:school_test/features/admin/data/models/resource_model.dart';
// ---------------------------------------
import '../../../../core/constants/api_constants.dart';

class AdminService {
  final Dio _dio;
  AdminService(this._dio);

  // ============================================================
  // USERS (existing)
  // ============================================================
  Future<List<AdminUserModel>> getUsers() async {
    final response = await _dio.get(ApiConstants.users);
    final List data = response.data['data'];
    return data.map((e) => AdminUserModel.fromJson(e)).toList();
  }

  Future<AdminUserModel> getUserById(int id) async {
    final response = await _dio.get(ApiConstants.userById(id));
    return AdminUserModel.fromJson(response.data['data']);
  }

  Future<void> createUser({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    await _dio.post(
      ApiConstants.users,
      data: {'name': name, 'email': email, 'password': password, 'role': role},
    );
  }

  Future<void> updateUser(
    int id, {
    String? name,
    String? email,
    String? role,
  }) async {
    final Map<String, dynamic> data = {};
    if (name != null) data['name'] = name;
    if (email != null) data['email'] = email;
    if (role != null) data['role'] = role;
    await _dio.put(ApiConstants.userById(id), data: data);
  }

  Future<void> deleteUser(int id) async {
    await _dio.delete(ApiConstants.userById(id));
  }

  // ============================================================
  // STUDENTS
  // ============================================================
  Future<List<AdminStudentModel>> getStudents() async {
    final response = await _dio.get(ApiConstants.students);
    final List data = response.data['data']['data'];
    return data.map((e) => AdminStudentModel.fromJson(e)).toList();
  }

  Future<AdminStudentModel> getStudentById(int id) async {
    final response = await _dio.get(ApiConstants.studentById(id));
    return AdminStudentModel.fromJson(response.data['data']);
  }

  Future<void> createStudent({
    required String name,
    required String email,
    required String password,
    required String studentId,
    required String dateOfBirth,
    required String gender,
    required String address,
    required String phone,
    required String enrollmentDate,
  }) async {
    await _dio.post(
      ApiConstants.students,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'student_id': studentId,
        'date_of_birth': dateOfBirth,
        'gender': gender,
        'address': address,
        'phone': phone,
        'enrollment_date': enrollmentDate,
      },
    );
  }

  Future<void> updateStudent(int id, Map<String, dynamic> data) async {
    await _dio.put(ApiConstants.studentById(id), data: data);
  }

  Future<void> deleteStudent(int id) async {
    await _dio.delete(ApiConstants.studentById(id));
  }

  // ============================================================
  // TEACHERS
  // ============================================================
  Future<List<AdminTeacherModel>> getTeachers() async {
    final response = await _dio.get(ApiConstants.teachers);
    final List data = response.data['data']['data'];
    return data.map((e) => AdminTeacherModel.fromJson(e)).toList();
  }

  Future<AdminTeacherModel> getTeacherById(int id) async {
    final response = await _dio.get(ApiConstants.teacherById(id));
    return AdminTeacherModel.fromJson(response.data['data']);
  }

  Future<void> createTeacher({
    required String name,
    required String email,
    required String password,
    required String teacherId,
    required String dateOfBirth,
    required String gender,
    required String address,
    required String phone,
    required String hireDate,
    required String qualification,
    required String subjectSpecialization,
  }) async {
    await _dio.post(
      ApiConstants.teachers,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'teacher_id': teacherId,
        'date_of_birth': dateOfBirth,
        'gender': gender,
        'address': address,
        'phone': phone,
        'hire_date': hireDate,
        'qualification': qualification,
        'subject_specialization': subjectSpecialization,
      },
    );
  }

  Future<void> updateTeacher(int id, Map<String, dynamic> data) async {
    await _dio.put(ApiConstants.teacherById(id), data: data);
  }

  Future<void> deleteTeacher(int id) async {
    await _dio.delete(ApiConstants.teacherById(id));
  }

  // Teacher relationships
  Future<void> changeTeacherRole(int classroomId, int teacherId, String role) async {
    await _dio.put(
      ApiConstants.updateTeacherRole,
      data: {'classroom_id': classroomId, 'teacher_id': teacherId, 'role': role},
    );
  }

  Future<void> changeSubjectTeacher(int classroomId, int subjectId, int newTeacherId) async {
    await _dio.put(
      ApiConstants.changeSubjectTeacher,
      data: {
        'classroom_id': classroomId,
        'subject_id': subjectId,
        'new_teacher_id': newTeacherId,
      },
    );
  }

  Future<void> updateSubjectHours(int classroomId, int subjectId, int weeklyHours) async {
    await _dio.put(
      ApiConstants.updateSubjectHours,
      data: {
        'classroom_id': classroomId,
        'subject_id': subjectId,
        'weekly_hours': weeklyHours,
      },
    );
  }

  Future<List<dynamic>> getTeacherClassrooms(int teacherId) async {
    final response = await _dio.get(ApiConstants.teacherClassrooms(teacherId));
    return response.data['data'] as List;
  }

  Future<List<dynamic>> getTeacherStudents(int teacherId) async {
    final response = await _dio.get(ApiConstants.teacherStudents(teacherId));
    return response.data['data']['data'] as List;
  }

  // ============================================================
  // PARENTS
  // ============================================================
  Future<List<AdminParentModel>> getParents() async {
    final response = await _dio.get(ApiConstants.parents);
    final List data = response.data['data']['data'];
    return data.map((e) => AdminParentModel.fromJson(e)).toList();
  }

  Future<AdminParentModel> getParentById(int id) async {
    final response = await _dio.get(ApiConstants.parentById(id));
    return AdminParentModel.fromJson(response.data['data']);
  }

  Future<void> createParent({
    required String name,
    required String email,
    required String password,
    required String parentId,
    required String phone,
    required String address,
    required String occupation,
  }) async {
    await _dio.post(
      ApiConstants.parents,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'parent_id': parentId,
        'phone': phone,
        'address': address,
        'occupation': occupation,
      },
    );
  }

  Future<void> updateParent(int id, Map<String, dynamic> data) async {
    await _dio.put(ApiConstants.parentById(id), data: data);
  }

  Future<void> deleteParent(int id) async {
    await _dio.delete(ApiConstants.parentById(id));
  }

  // ============================================================
  // NOTIFICATIONS
  // ============================================================
  Future<List<AdminNotificationModel>> getNotifications() async {
    final response = await _dio.get(ApiConstants.notifications);
    final List data = response.data['data']['data'];
    return data.map((e) => AdminNotificationModel.fromJson(e)).toList();
  }

  Future<int> getUnreadCount() async {
    final response = await _dio.get(ApiConstants.notificationsUnreadCount);
    final data = response.data['data'];
    return data['count'] ?? data['unread_count'] ?? 0;
  }

  Future<void> markAllRead() async {
    await _dio.post(ApiConstants.notificationsMarkAllRead);
  }

  Future<void> markOneRead(int id) async {
    await _dio.post(ApiConstants.notificationMarkRead(id));
  }

  Future<void> deleteNotification(int id) async {
    await _dio.delete(ApiConstants.notificationById(id));
  }

  // ============================================================
  // CLASSROOMS
  // ============================================================
  Future<List<ClassroomModel>> getClassrooms() async {
    final response = await _dio.get(ApiConstants.classrooms);
    final List data = response.data['data']['data'];
    return data.map((e) => ClassroomModel.fromJson(e)).toList();
  }

  Future<ClassroomModel> getClassroomById(int id) async {
    final response = await _dio.get(ApiConstants.classroomById(id));
    return ClassroomModel.fromJson(response.data['data']);
  }

  Future<void> createClassroom(Map<String, dynamic> data) async {
    await _dio.post(ApiConstants.classrooms, data: data);
  }

  Future<void> updateClassroom(int id, Map<String, dynamic> data) async {
    await _dio.put(ApiConstants.classroomById(id), data: data);
  }

  Future<void> deleteClassroom(int id) async {
    await _dio.delete(ApiConstants.classroomById(id));
  }

  // ============================================================
  // CLASSROOM RELATIONSHIPS
  // ============================================================
  Future<void> enrollStudent(int classroomId, int studentId) async {
    await _dio.post(
      ApiConstants.enrollStudent,
      data: {
        'classroom_id': classroomId,
        'student_id': studentId,
        'status': 'active',
        'enrolled_at': DateTime.now().toIso8601String().split('T')[0],
      },
    );
  }

  Future<void> removeStudent(int classroomId, int studentId) async {
    await _dio.delete(
      ApiConstants.removeStudent,
      data: {'classroom_id': classroomId, 'student_id': studentId},
    );
  }

  Future<void> assignTeacher(int classroomId, int teacherId) async {
    await _dio.post(
      ApiConstants.assignTeacher,
      data: {
        'classroom_id': classroomId,
        'teacher_id': teacherId,
        'role': 'homeroom',
        'assigned_at': DateTime.now().toIso8601String().split('T')[0],
      },
    );
  }

  Future<void> removeTeacher(int classroomId, int teacherId) async {
    await _dio.delete(
      ApiConstants.removeTeacher,
      data: {'classroom_id': classroomId, 'teacher_id': teacherId},
    );
  }

  Future<void> assignSubject(int classroomId, int subjectId, int teacherId) async {
    await _dio.post(
      ApiConstants.assignSubject,
      data: {
        'classroom_id': classroomId,
        'subject_id': subjectId,
        'teacher_id': teacherId,
        'weekly_hours': 5,
        'semester': 'first',
        'academic_year': '2024-2025',
      },
    );
  }

  Future<void> removeSubject(int classroomId, int subjectId) async {
    await _dio.delete(
      ApiConstants.removeSubject,
      data: {'classroom_id': classroomId, 'subject_id': subjectId},
    );
  }

  Future<Map<String, dynamic>> getClassroomRelationships(int classroomId) async {
    final response = await _dio.get(ApiConstants.classroomRelationships(classroomId));
    return response.data['data'];
  }

  // ============================================================
  // SUBJECTS
  // ============================================================
  Future<List<SubjectModel>> getSubjects() async {
    final response = await _dio.get(ApiConstants.subjects);
    final List data = response.data['data']['data'];
    return data.map((e) => SubjectModel.fromJson(e)).toList();
  }

  Future<SubjectModel> getSubjectById(int id) async {
    final response = await _dio.get(ApiConstants.subjectById(id));
    return SubjectModel.fromJson(response.data['data']);
  }

  Future<void> createSubject(Map<String, dynamic> data) async {
    await _dio.post(ApiConstants.subjects, data: data);
  }

  Future<void> updateSubject(int id, Map<String, dynamic> data) async {
    await _dio.put(ApiConstants.subjectById(id), data: data);
  }

  Future<void> deleteSubject(int id) async {
    await _dio.delete(ApiConstants.subjectById(id));
  }

  // ============================================================
  // SCHEDULES
  // ============================================================
  Future<List<ScheduleModel>> getSchedules() async {
    final response = await _dio.get(ApiConstants.schedules);
    final List data = response.data['data']['data'];
    return data.map((e) => ScheduleModel.fromJson(e)).toList();
  }

  Future<ScheduleModel> getScheduleById(int id) async {
    final response = await _dio.get(ApiConstants.scheduleById(id));
    return ScheduleModel.fromJson(response.data['data']);
  }

  Future<void> createSchedule(Map<String, dynamic> data) async {
    await _dio.post(ApiConstants.schedules, data: data);
  }

  Future<void> updateSchedule(int id, Map<String, dynamic> data) async {
    await _dio.put(ApiConstants.scheduleById(id), data: data);
  }

  Future<void> deleteSchedule(int id) async {
    await _dio.delete(ApiConstants.scheduleById(id));
  }

  // ============================================================
  // ATTENDANCES (new)
  // ============================================================
  Future<List<AttendanceModel>> getAttendances() async {
    final response = await _dio.get(ApiConstants.attendances);
    final List data = response.data['data']['data'];
    return data.map((e) => AttendanceModel.fromJson(e)).toList();
  }

  Future<AttendanceModel> getAttendanceById(int id) async {
    final response = await _dio.get(ApiConstants.attendanceById(id));
    return AttendanceModel.fromJson(response.data['data']);
  }

  Future<void> createAttendance(Map<String, dynamic> data) async {
    await _dio.post(ApiConstants.attendances, data: data);
  }

  Future<void> updateAttendance(int id, Map<String, dynamic> data) async {
    await _dio.put(ApiConstants.attendanceById(id), data: data);
  }

  Future<void> deleteAttendance(int id) async {
    await _dio.delete(ApiConstants.attendanceById(id));
  }

  // ============================================================
  // EXAMS (new)
  // ============================================================
  Future<List<ExamModel>> getExams() async {
    final response = await _dio.get(ApiConstants.exams);
    final List data = response.data['data']['data'];
    return data.map((e) => ExamModel.fromJson(e)).toList();
  }

  Future<ExamModel> getExamById(int id) async {
    final response = await _dio.get(ApiConstants.examById(id));
    return ExamModel.fromJson(response.data['data']);
  }

  Future<void> createExam(Map<String, dynamic> data) async {
    await _dio.post(ApiConstants.exams, data: data);
  }

  Future<void> updateExam(int id, Map<String, dynamic> data) async {
    await _dio.put(ApiConstants.examById(id), data: data);
  }

  Future<void> deleteExam(int id) async {
    await _dio.delete(ApiConstants.examById(id));
  }

  // ============================================================
  // GRADES (new)
  // ============================================================
  Future<List<GradeModel>> getGrades() async {
    final response = await _dio.get(ApiConstants.grades);
    final List data = response.data['data']['data'];
    return data.map((e) => GradeModel.fromJson(e)).toList();
  }

  Future<GradeModel> getGradeById(int id) async {
    final response = await _dio.get(ApiConstants.gradeById(id));
    return GradeModel.fromJson(response.data['data']);
  }

  Future<void> createGrade(Map<String, dynamic> data) async {
    await _dio.post(ApiConstants.grades, data: data);
  }

  Future<void> updateGrade(int id, Map<String, dynamic> data) async {
    await _dio.put(ApiConstants.gradeById(id), data: data);
  }

  Future<void> deleteGrade(int id) async {
    await _dio.delete(ApiConstants.gradeById(id));
  }

  // ============================================================
  // ASSIGNMENTS (new)
  // ============================================================
  Future<List<AssignmentModel>> getAssignments() async {
    final response = await _dio.get(ApiConstants.assignments);
    final List data = response.data['data']['data'];
    return data.map((e) => AssignmentModel.fromJson(e)).toList();
  }

  Future<AssignmentModel> getAssignmentById(int id) async {
    final response = await _dio.get(ApiConstants.assignmentById(id));
    return AssignmentModel.fromJson(response.data['data']);
  }

  Future<void> createAssignment(Map<String, dynamic> data) async {
    await _dio.post(ApiConstants.assignments, data: data);
  }

  Future<void> updateAssignment(int id, Map<String, dynamic> data) async {
    await _dio.put(ApiConstants.assignmentById(id), data: data);
  }

  Future<void> deleteAssignment(int id) async {
    await _dio.delete(ApiConstants.assignmentById(id));
  }

  // Assignment submission (student)
  Future<void> submitAssignment(int assignmentId, FormData formData) async {
    await _dio.post(ApiConstants.submitAssignment(assignmentId), data: formData);
  }

  // ============================================================
  // SUBMISSIONS
  // ============================================================
  Future<List<SubmissionModel>> getSubmissions() async {
    final response = await _dio.get(ApiConstants.submissions);
    final List data = response.data['data']['data'];
    return data.map((e) => SubmissionModel.fromJson(e)).toList();
  }

  Future<SubmissionModel> getSubmissionById(int id) async {
    final response = await _dio.get(ApiConstants.submissionById(id));
    return SubmissionModel.fromJson(response.data['data']);
  }

  Future<void> deleteSubmission(int id) async {
    await _dio.delete(ApiConstants.submissionById(id));
  }

  Future<void> gradeSubmission(int submissionId, Map<String, dynamic> data) async {
    await _dio.post(ApiConstants.gradeSubmission(submissionId), data: data);
  }

  // ============================================================
  // FILES
  // ============================================================
  Future<Map<String, dynamic>> uploadFile(FormData formData) async {
    final response = await _dio.post(ApiConstants.fileUpload, data: formData);
    return response.data;
  }

  Future<Map<String, dynamic>> uploadMultipleFiles(FormData formData) async {
    final response = await _dio.post(ApiConstants.fileUploadMultiple, data: formData);
    return response.data;
  }

  Future<void> deleteFile(String filePath) async {
    await _dio.delete(ApiConstants.fileDelete, data: {'file_path': filePath});
  }

  // ============================================================
  // MESSAGES
  // ============================================================
  Future<List<MessageModel>> getMessages({String? type, int? studentId}) async {
    final query = <String, dynamic>{};
    if (type != null) query['type'] = type;
    if (studentId != null) query['student_id'] = studentId;
    final response = await _dio.get(ApiConstants.messages, queryParameters: query);
    final List data = response.data['data']['data'];
    return data.map((e) => MessageModel.fromJson(e)).toList();
  }

  Future<void> sendMessage(Map<String, dynamic> data) async {
    await _dio.post(ApiConstants.messages, data: data);
  }

  Future<int> getMessagesUnreadCount() async {
    final response = await _dio.get(ApiConstants.messagesUnreadCount);
    return response.data['data']['count'] ?? 0;
  }

  Future<List<dynamic>> getAvailableParents({String? search}) async {
    final query = search != null ? {'search': search} : null;
    final response = await _dio.get(ApiConstants.messagesAvailableParents, queryParameters: query);
    return response.data['data'] as List;
  }

  // ============================================================
  // RESOURCES
  // ============================================================
  Future<List<ResourceModel>> getResources({
    String? type,
    int? subjectId,
    String? search,
  }) async {
    final query = <String, dynamic>{};
    if (type != null) query['type'] = type;
    if (subjectId != null) query['subject_id'] = subjectId;
    if (search != null) query['search'] = search;
    final response = await _dio.get(ApiConstants.resources, queryParameters: query);
    final List data = response.data['data']['data'];
    return data.map((e) => ResourceModel.fromJson(e)).toList();
  }

  Future<ResourceModel> uploadResource(FormData formData) async {
    final response = await _dio.post(ApiConstants.resources, data: formData);
    return ResourceModel.fromJson(response.data['data']);
  }

  Future<Map<String, dynamic>> downloadResource(int id) async {
    final response = await _dio.get(ApiConstants.resourceDownload(id));
    return response.data['data'];
  }

  Future<List<ResourceModel>> getMyResources({String? type}) async {
    final query = type != null ? {'type': type} : null;
    final response = await _dio.get(ApiConstants.resourcesMy, queryParameters: query);
    final List data = response.data['data']['data'];
    return data.map((e) => ResourceModel.fromJson(e)).toList();
  }

  Future<List<ResourceModel>> getPopularResources() async {
    final response = await _dio.get(ApiConstants.resourcesPopular);
    final List data = response.data['data']['data'];
    return data.map((e) => ResourceModel.fromJson(e)).toList();
  }

  // ============================================================
  // TEACHER "ME" ENDPOINTS
  // ============================================================
  Future<List<dynamic>> getMyClassrooms() async {
    final response = await _dio.get(ApiConstants.myClassrooms);
    return response.data['data'] as List;
  }

  Future<List<dynamic>> getMyStudents() async {
    final response = await _dio.get(ApiConstants.myStudents);
    return response.data['data']['data'] as List;
  }
}