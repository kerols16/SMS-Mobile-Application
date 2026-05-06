import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:school_test/features/admin/data/models/notification_model.dart';
import 'package:school_test/features/admin/data/models/parent_model.dart';
import 'package:school_test/features/admin/data/models/student_model.dart';
import 'package:school_test/features/admin/data/models/teacher_model.dart';
import 'package:school_test/features/admin/data/models/user_model.dart';
import '../../../../core/constants/api_constants.dart';

class AdminService {
  final Dio _dio;
  AdminService(this._dio);

  // ═══════════════════════════════════════
  // USERS
  // ═══════════════════════════════════════
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



  // ═══════════════════════════════════════
  // STUDENTS
  // ═══════════════════════════════════════
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

  // ═══════════════════════════════════════
  // TEACHERS
  // ═══════════════════════════════════════
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

  // ═══════════════════════════════════════
  // PARENTS
  // ═══════════════════════════════════════
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

  // ═══════════════════════════════════════
  // NOTIFICATIONS
  // ═══════════════════════════════════════
  Future<List<AdminNotificationModel>> getNotifications() async {
    final response = await _dio.get(ApiConstants.notifications);
    final List data = response.data['data']['data'];
    return data.map((e) => AdminNotificationModel.fromJson(e)).toList();
  }

  Future<int> getUnreadCount() async {
    final response = await _dio.get(ApiConstants.notificationsUnreadCount);

    debugPrint("📦 FULL RESPONSE: ${response.data}");

    final data = response.data;
    if (data == null) return 0;

    final innerData = data['data'];
    if (innerData == null) return 0;

    // API returns 'count' not 'unread_count'
    return innerData['count'] ?? innerData['unread_count'] ?? 0;
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
}
