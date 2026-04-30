import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../data/admin_service.dart';
import '../../data/models/user_model.dart';
import '../../data/models/student_model.dart';
import '../../data/models/teacher_model.dart';
import '../../data/models/parent_model.dart';
import '../../data/models/notification_model.dart';

part 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  final AdminService _service;
  AdminCubit(this._service) : super(AdminInitial());

  // ═══════════════════════════════════════
  // LOAD ALL — called when dashboard opens
  // ═══════════════════════════════════════

  Future<void> loadDashboard() async {
    if (state is AdminLoading) return;
    emit(AdminLoading());
    try {
    final users = await _service.getUsers();
    debugPrint("✅ users loaded");

    final students = await _service.getStudents();
    debugPrint("✅ students loaded");

    final teachers = await _service.getTeachers();
    debugPrint("✅ teachers loaded");

    final parents = await _service.getParents();
    debugPrint("✅ parents loaded");

    final notifications = await _service.getNotifications();
    debugPrint("✅ notifications loaded");

    final unread = await _service.getUnreadCount();
    debugPrint("✅ unread loaded: $unread");

    emit(AdminLoaded(
      users: users,
      students: students,
      teachers: teachers,
      parents: parents,
      notifications: notifications,
      unreadCount: unread,
    ));
  } catch (e) {
    debugPrint("❌ ERROR: $e");
    emit(AdminError('Something went wrong'));
  }
  }

  // ═══════════════════════════════════════
  // USERS
  // ═══════════════════════════════════════
  Future<void> createUser({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    emit(AdminOperationLoading());
    try {
      await _service.createUser(
        name: name,
        email: email,
        password: password,
        role: role,
      );
      emit(AdminOperationSuccess('User created successfully'));
      await loadDashboard();
    } on DioException catch (e) {
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      emit(AdminOperationError('Failed to create user'));
    }
  }

  Future<void> updateUser(
    int id, {
    String? name,
    String? email,
    String? role,
  }) async {
    emit(AdminOperationLoading());
    try {
      await _service.updateUser(id, name: name, email: email, role: role);
      emit(AdminOperationSuccess('User updated successfully'));
      await loadDashboard();
    } on DioException catch (e) {
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      emit(AdminOperationError('Failed to update user'));
    }
  }

  Future<void> deleteUser(int id) async {
    emit(AdminOperationLoading());
    try {
      await _service.deleteUser(id);
      emit(AdminOperationSuccess('User deleted successfully'));
      await loadDashboard();
    } on DioException catch (e) {
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      emit(AdminOperationError('Failed to delete user'));
    }
  }

  // ═══════════════════════════════════════
  // STUDENTS
  // ═══════════════════════════════════════
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
    emit(AdminOperationLoading());
    try {
      await _service.createStudent(
        name: name,
        email: email,
        password: password,
        studentId: studentId,
        dateOfBirth: dateOfBirth,
        gender: gender,
        address: address,
        phone: phone,
        enrollmentDate: enrollmentDate,
      );
      emit(AdminOperationSuccess('Student created successfully'));
      await loadDashboard();
    } on DioException catch (e) {
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      emit(AdminOperationError('Failed to create student'));
    }
  }

  Future<void> updateStudent(int id, Map<String, dynamic> data) async {
    emit(AdminOperationLoading());
    try {
      await _service.updateStudent(id, data);
      emit(AdminOperationSuccess('Student updated successfully'));
      await loadDashboard();
    } on DioException catch (e) {
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      emit(AdminOperationError('Failed to update student'));
    }
  }

  Future<void> deleteStudent(int id) async {
    emit(AdminOperationLoading());
    try {
      await _service.deleteStudent(id);
      emit(AdminOperationSuccess('Student deleted successfully'));
      await loadDashboard();
    } on DioException catch (e) {
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      emit(AdminOperationError('Failed to delete student'));
    }
  }

  // ═══════════════════════════════════════
  // TEACHERS
  // ═══════════════════════════════════════
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
    emit(AdminOperationLoading());
    try {
      await _service.createTeacher(
        name: name,
        email: email,
        password: password,
        teacherId: teacherId,
        dateOfBirth: dateOfBirth,
        gender: gender,
        address: address,
        phone: phone,
        hireDate: hireDate,
        qualification: qualification,
        subjectSpecialization: subjectSpecialization,
      );
      emit(AdminOperationSuccess('Teacher created successfully'));
      await loadDashboard();
    } on DioException catch (e) {
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      emit(AdminOperationError('Failed to create teacher'));
    }
  }

  Future<void> updateTeacher(int id, Map<String, dynamic> data) async {
    emit(AdminOperationLoading());
    try {
      await _service.updateTeacher(id, data);
      emit(AdminOperationSuccess('Teacher updated successfully'));
      await loadDashboard();
    } on DioException catch (e) {
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      emit(AdminOperationError('Failed to update teacher'));
    }
  }

  Future<void> deleteTeacher(int id) async {
    emit(AdminOperationLoading());
    try {
      await _service.deleteTeacher(id);
      emit(AdminOperationSuccess('Teacher deleted successfully'));
      await loadDashboard();
    } on DioException catch (e) {
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      emit(AdminOperationError('Failed to delete teacher'));
    }
  }

  // ═══════════════════════════════════════
  // PARENTS
  // ═══════════════════════════════════════
  Future<void> createParent({
    required String name,
    required String email,
    required String password,
    required String parentId,
    required String phone,
    required String address,
    required String occupation,
  }) async {
    emit(AdminOperationLoading());
    try {
      await _service.createParent(
        name: name,
        email: email,
        password: password,
        parentId: parentId,
        phone: phone,
        address: address,
        occupation: occupation,
      );
      emit(AdminOperationSuccess('Parent created successfully'));
      await loadDashboard();
    } on DioException catch (e) {
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      emit(AdminOperationError('Failed to create parent'));
    }
  }

  Future<void> updateParent(int id, Map<String, dynamic> data) async {
    emit(AdminOperationLoading());
    try {
      await _service.updateParent(id, data);
      emit(AdminOperationSuccess('Parent updated successfully'));
      await loadDashboard();
    } on DioException catch (e) {
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      emit(AdminOperationError('Failed to update parent'));
    }
  }

  Future<void> deleteParent(int id) async {
    emit(AdminOperationLoading());
    try {
      await _service.deleteParent(id);
      emit(AdminOperationSuccess('Parent deleted successfully'));
      await loadDashboard();
    } on DioException catch (e) {
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      emit(AdminOperationError('Failed to delete parent'));
    }
  }

  // ═══════════════════════════════════════
  // NOTIFICATIONS
  // ═══════════════════════════════════════
  Future<void> markAllRead() async {
    try {
      await _service.markAllRead();
      if (state is AdminLoaded) {
        final current = state as AdminLoaded;
        final updated = current.notifications
            .map(
              (n) => AdminNotificationModel(
                id: n.id,
                type: n.type,
                title: n.title,
                message: n.message,
                link: n.link,
                isRead: true,
                createdAt: n.createdAt,
              ),
            )
            .toList();
        emit(current.copyWith(notifications: updated, unreadCount: 0));
      }
    } on DioException catch (e) {
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      emit(AdminOperationError('Failed to mark notifications as read'));
    }
  }

  Future<void> markOneRead(int id) async {
    try {
      await _service.markOneRead(id);
      if (state is AdminLoaded) {
        final current = state as AdminLoaded;
        final updated = current.notifications.map((n) {
          return n.id == id
              ? AdminNotificationModel(
                  id: n.id,
                  type: n.type,
                  title: n.title,
                  message: n.message,
                  link: n.link,
                  isRead: true,
                  createdAt: n.createdAt,
                )
              : n;
        }).toList();
        final newUnread = updated.where((n) => !n.isRead).length;
        emit(current.copyWith(notifications: updated, unreadCount: newUnread));
      }
    } catch (_) {}
  }

  Future<void> deleteNotification(int id) async {
    emit(AdminOperationLoading());
    try {
      await _service.deleteNotification(id);
      emit(AdminOperationSuccess('Notification deleted'));
      await loadDashboard();
    } on DioException catch (e) {
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      emit(AdminOperationError('Failed to delete notification'));
    }
  }

  // ═══════════════════════════════════════
  // ERROR HANDLER
  // ═══════════════════════════════════════
  String _handleDioError(DioException e) {
    debugPrint("❌ DIO ERROR TYPE: ${e.type}");
    debugPrint("📡 STATUS CODE: ${e.response?.statusCode}");
    debugPrint("📦 RESPONSE DATA: ${e.response?.data}");
    debugPrint("🧾 ERROR MESSAGE: ${e.message}");

    // 🔐 Status codes
    switch (e.response?.statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized access';
      case 403:
        return 'You do not have permission';
      case 404:
        return 'Resource not found';
      case 422:
        return 'Invalid data, please check your input';
      case 500:
        return 'Server error, please try again later';
    }

    // 🌐 Network مشاكل
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout, please try again';

      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Request timeout, please try again';

      case DioExceptionType.badCertificate:
        return 'Bad certificate';

      case DioExceptionType.cancel:
        return 'Request was cancelled';

      case DioExceptionType.connectionError:
        return 'No internet connection';

      case DioExceptionType.unknown:
        return 'Unexpected error occurred';
      case DioExceptionType.badResponse:
    }

    return e.message ?? 'Something went wrong';
  }
}
