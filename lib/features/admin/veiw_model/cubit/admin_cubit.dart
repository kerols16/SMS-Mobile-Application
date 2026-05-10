import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:school_test/features/admin/data/models/classroom_model.dart';
import 'package:school_test/features/admin/data/models/schedule_model.dart';
import 'package:school_test/features/admin/data/models/subject_model.dart';
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
    debugPrint("🔄 Loading dashboard...");
    try {
      final users = await _service.getUsers();
      debugPrint("✅ users loaded: ${users.length}");

      final students = await _service.getStudents();
      debugPrint("✅ students loaded: ${students.length}");

      final teachers = await _service.getTeachers();
      debugPrint("✅ teachers loaded: ${teachers.length}");

      final parents = await _service.getParents();
      debugPrint("✅ parents loaded: ${parents.length}");

      final notifications = await _service.getNotifications();
      debugPrint("✅ notifications loaded: ${notifications.length}");

      final unread = await _service.getUnreadCount();
      debugPrint("✅ unread loaded: $unread");

      final classrooms = await _service.getClassrooms();
      debugPrint("✅ classrooms loaded: ${classrooms.length}");

      final subjects = await _service.getSubjects();
      debugPrint("✅ subjects loaded: ${subjects.length}");

      final schedules = await _service.getSchedules();
      debugPrint("✅ schedules loaded: ${schedules.length}");

      emit(
        AdminLoaded(
          users: users,
          students: students,
          teachers: teachers,
          parents: parents,
          notifications: notifications,
          unreadCount: unread,
          classrooms: classrooms,
          subjects: subjects,
          schedules: schedules,
        ),
      );
      debugPrint("✅ Dashboard fully loaded");
    } catch (e) {
      debugPrint("❌ ERROR loading dashboard: $e");
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
    debugPrint("🔄 Creating user: $email ($role)");
    try {
      await _service.createUser(
        name: name,
        email: email,
        password: password,
        role: role,
      );
      debugPrint("✅ User created: $email");
      emit(AdminOperationSuccess('User created successfully'));
      await loadDashboard();
    } on DioException catch (e) {
      debugPrint("❌ Failed to create user: ${_handleDioError(e)}");
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      debugPrint("❌ Failed to create user: $e");
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
    debugPrint("🔄 Updating user ID: $id");
    try {
      await _service.updateUser(id, name: name, email: email, role: role);
      debugPrint("✅ User updated: ID $id");
      emit(AdminOperationSuccess('User updated successfully'));
    } on DioException catch (e) {
      debugPrint("❌ Failed to update user: ${_handleDioError(e)}");
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      debugPrint("❌ Failed to update user: $e");
      emit(AdminOperationError('Failed to update user'));
    }
  }

  Future<void> deleteUser(int id) async {
    emit(AdminOperationLoading());
    debugPrint("🔄 Deleting user ID: $id");
    try {
      await _service.deleteUser(id);
      debugPrint("✅ User deleted: ID $id");
      emit(AdminOperationSuccess('User deleted successfully'));
      await loadDashboard();
    } on DioException catch (e) {
      debugPrint("❌ Failed to delete user: ${_handleDioError(e)}");
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      debugPrint("❌ Failed to delete user: $e");
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
    debugPrint("🔄 Creating student: $name ($studentId)");
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
      debugPrint("✅ Student created: $studentId");
      emit(AdminOperationSuccess('Student created successfully'));
      await loadDashboard();
    } on DioException catch (e) {
      debugPrint("❌ Failed to create student: ${_handleDioError(e)}");
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      debugPrint("❌ Failed to create student: $e");
      emit(AdminOperationError('Failed to create student'));
    }
  }

  Future<void> updateStudent(int id, Map<String, dynamic> data) async {
    emit(AdminOperationLoading());
    debugPrint("🔄 Updating student ID: $id");
    try {
      await _service.updateStudent(id, data);
      debugPrint("✅ Student updated: ID $id");
      emit(AdminOperationSuccess('Student updated successfully'));
    } on DioException catch (e) {
      debugPrint("❌ Failed to update student: ${_handleDioError(e)}");
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      debugPrint("❌ Failed to update student: $e");
      emit(AdminOperationError('Failed to update student'));
    }
  }

  Future<void> deleteStudent(int id) async {
    emit(AdminOperationLoading());
    debugPrint("🔄 Deleting student ID: $id");
    try {
      await _service.deleteStudent(id);
      debugPrint("✅ Student deleted: ID $id");
      emit(AdminOperationSuccess('Student deleted successfully'));
      await loadDashboard();
    } on DioException catch (e) {
      debugPrint("❌ Failed to delete student: ${_handleDioError(e)}");
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      debugPrint("❌ Failed to delete student: $e");
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
    debugPrint("🔄 Creating teacher: $name ($teacherId)");
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
      debugPrint("✅ Teacher created: $teacherId");
      emit(AdminOperationSuccess('Teacher created successfully'));
      await loadDashboard();
    } on DioException catch (e) {
      debugPrint("❌ Failed to create teacher: ${_handleDioError(e)}");
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      debugPrint("❌ Failed to create teacher: $e");
      emit(AdminOperationError('Failed to create teacher'));
    }
  }

  Future<void> updateTeacher(int id, Map<String, dynamic> data) async {
    emit(AdminOperationLoading());
    debugPrint("🔄 Updating teacher ID: $id");
    try {
      await _service.updateTeacher(id, data);
      debugPrint("✅ Teacher updated: ID $id");
      emit(AdminOperationSuccess('Teacher updated successfully'));
    } on DioException catch (e) {
      debugPrint("❌ Failed to update teacher: ${_handleDioError(e)}");
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      debugPrint("❌ Failed to update teacher: $e");
      emit(AdminOperationError('Failed to update teacher'));
    }
  }

  Future<void> deleteTeacher(int id) async {
    emit(AdminOperationLoading());
    debugPrint("🔄 Deleting teacher ID: $id");
    try {
      await _service.deleteTeacher(id);
      debugPrint("✅ Teacher deleted: ID $id");
      emit(AdminOperationSuccess('Teacher deleted successfully'));
      await loadDashboard();
    } on DioException catch (e) {
      debugPrint("❌ Failed to delete teacher: ${_handleDioError(e)}");
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      debugPrint("❌ Failed to delete teacher: $e");
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
    debugPrint("🔄 Creating parent: $name ($parentId)");
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
      debugPrint("✅ Parent created: $parentId");
      emit(AdminOperationSuccess('Parent created successfully'));
      await loadDashboard();
    } on DioException catch (e) {
      debugPrint("❌ Failed to create parent: ${_handleDioError(e)}");
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      debugPrint("❌ Failed to create parent: $e");
      emit(AdminOperationError('Failed to create parent'));
    }
  }

  Future<void> updateParent(int id, Map<String, dynamic> data) async {
    emit(AdminOperationLoading());
    debugPrint("🔄 Updating parent ID: $id");
    try {
      await _service.updateParent(id, data);
      debugPrint("✅ Parent updated: ID $id");
      emit(AdminOperationSuccess('Parent updated successfully'));
    } on DioException catch (e) {
      debugPrint("❌ Failed to update parent: ${_handleDioError(e)}");
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      debugPrint("❌ Failed to update parent: $e");
      emit(AdminOperationError('Failed to update parent'));
    }
  }

  Future<void> deleteParent(int id) async {
    emit(AdminOperationLoading());
    debugPrint("🔄 Deleting parent ID: $id");
    try {
      await _service.deleteParent(id);
      debugPrint("✅ Parent deleted: ID $id");
      emit(AdminOperationSuccess('Parent deleted successfully'));
      await loadDashboard();
    } on DioException catch (e) {
      debugPrint("❌ Failed to delete parent: ${_handleDioError(e)}");
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      debugPrint("❌ Failed to delete parent: $e");
      emit(AdminOperationError('Failed to delete parent'));
    }
  }

  // ═══════════════════════════════════════
  // NOTIFICATIONS
  // ═══════════════════════════════════════
  Future<void> markAllRead() async {
    debugPrint("🔄 Marking all notifications as read");
    try {
      await _service.markAllRead();
      debugPrint("✅ All notifications marked as read");
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
      debugPrint("❌ Failed to mark all read: ${_handleDioError(e)}");
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      debugPrint("❌ Failed to mark all read: $e");
      emit(AdminOperationError('Failed to mark notifications as read'));
    }
  }

  Future<void> markOneRead(int id) async {
    debugPrint("🔄 Marking notification ID $id as read");
    try {
      await _service.markOneRead(id);
      debugPrint("✅ Notification ID $id marked as read");
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
    } on DioException catch (e) {
      debugPrint("❌ Failed to mark notification read: ${_handleDioError(e)}");
    } catch (e) {
      debugPrint("❌ Failed to mark notification read: $e");
    }
  }

  Future<void> deleteNotification(int id) async {
    emit(AdminOperationLoading());
    debugPrint("🔄 Deleting notification ID: $id");
    try {
      await _service.deleteNotification(id);
      debugPrint("✅ Notification deleted: ID $id");
      emit(AdminOperationSuccess('Notification deleted'));
      await loadDashboard();
    } on DioException catch (e) {
      debugPrint("❌ Failed to delete notification: ${_handleDioError(e)}");
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      debugPrint("❌ Failed to delete notification: $e");
      emit(AdminOperationError('Failed to delete notification'));
    }
  }

  // ═══════════════════════════════════════
  // CLASSROOMS
  // ═══════════════════════════════════════
  Future<void> createClassroom(Map<String, dynamic> data) async {
    emit(AdminOperationLoading());
    debugPrint("🔄 Creating classroom: ${data['name']}");
    try {
      await _service.createClassroom(data);
      debugPrint("✅ Classroom created: ${data['name']}");
      emit(AdminOperationSuccess('Classroom created successfully'));
      await loadDashboard();
    } on DioException catch (e) {
      debugPrint("❌ Failed to create classroom: ${_handleDioError(e)}");
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      debugPrint("❌ Failed to create classroom: $e");
      emit(AdminOperationError('Failed to create classroom'));
    }
  }

 Future<void> getClassroomById(int id) async {
  emit(AdminLoading());
  debugPrint("🔄 Loading classroom ID: $id");
  try {
    final data = await _service.getClassroomRelationships(id); // ← غيّر السطر ده
    
    final classroomJson = Map<String, dynamic>.from(data['classroom']);
    classroomJson['students'] = data['students'] ?? [];
    classroomJson['teachers'] = data['teachers'] ?? [];
    classroomJson['subjects'] = data['subjects'] ?? [];
    
    debugPrint("✅ Classroom loaded: ID $id");
    debugPrint("🔍 students count: ${classroomJson['students'].length}");
    emit(ClassroomLoaded(ClassroomModel.fromJson(classroomJson)));
  } catch (e) {
    debugPrint("❌ Failed to load classroom ID $id: $e");
    emit(AdminOperationError('Failed to load classroom'));
  }
}
  Future<void> updateClassroom(int id, Map<String, dynamic> data) async {
    emit(AdminOperationLoading());
    debugPrint("🔄 Updating classroom ID: $id");
    try {
      await _service.updateClassroom(id, data);
      debugPrint("✅ Classroom updated: ID $id");
      emit(AdminOperationSuccess('Classroom updated successfully'));
      await loadDashboard();
    } on DioException catch (e) {
      debugPrint("❌ Failed to update classroom: ${_handleDioError(e)}");
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      debugPrint("❌ Failed to update classroom: $e");
      emit(AdminOperationError('Failed to update classroom'));
    }
  }

  Future<void> deleteClassroom(int id) async {
    emit(AdminOperationLoading());
    debugPrint("🔄 Deleting classroom ID: $id");
    try {
      await _service.deleteClassroom(id);
      debugPrint("✅ Classroom deleted: ID $id");
      emit(AdminOperationSuccess('Classroom deleted successfully'));
      await loadDashboard();
    } on DioException catch (e) {
      debugPrint("❌ Failed to delete classroom: ${_handleDioError(e)}");
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      debugPrint("❌ Failed to delete classroom: $e");
      emit(AdminOperationError('Failed to delete classroom'));
    }
  }

  // ═══════════════════════════════════════
  // CLASSROOM RELATIONSHIPS
  // ═══════════════════════════════════════
  Future<void> enrollStudent(int classroomId, int studentId) async {
    emit(AdminOperationLoading());
    debugPrint("🔄 Enrolling student ID $studentId into classroom ID $classroomId");
    try {
      await _service.enrollStudent(classroomId, studentId);
      debugPrint("✅ Student ID $studentId enrolled into classroom ID $classroomId");
      emit(AdminOperationSuccess('Student enrolled successfully'));
      await getClassroomById(classroomId);
    } on DioException catch (e) {
      debugPrint("❌ Failed to enroll student: ${_handleDioError(e)}");
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      debugPrint("❌ Failed to enroll student: $e");
      emit(AdminOperationError('Failed to enroll student'));
    }
  }

  Future<void> removeStudent(int classroomId, int studentId) async {
    emit(AdminOperationLoading());
    debugPrint("🔄 Removing student ID $studentId from classroom ID $classroomId");
    try {
      await _service.removeStudent(classroomId, studentId);
      debugPrint("✅ Student ID $studentId removed from classroom ID $classroomId");
      emit(AdminOperationSuccess('Student removed'));
      await getClassroomById(classroomId);
    } on DioException catch (e) {
      debugPrint("❌ Failed to remove student: ${_handleDioError(e)}");
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      debugPrint("❌ Failed to remove student: $e");
      emit(AdminOperationError('Failed to remove student'));
    }
  }

  Future<void> assignTeacher(int classroomId, int teacherId) async {
    emit(AdminOperationLoading());
    debugPrint("🔄 Assigning teacher ID $teacherId to classroom ID $classroomId");
    try {
      await _service.assignTeacher(classroomId, teacherId);
      debugPrint("✅ Teacher ID $teacherId assigned to classroom ID $classroomId");
      emit(AdminOperationSuccess('Teacher assigned successfully'));
      await getClassroomById(classroomId);
    } on DioException catch (e) {
      debugPrint("❌ Failed to assign teacher: ${_handleDioError(e)}");
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      debugPrint("❌ Failed to assign teacher: $e");
      emit(AdminOperationError('Failed to assign teacher'));
    }
  }

  Future<void> removeTeacher(int classroomId, int teacherId) async {
    emit(AdminOperationLoading());
    debugPrint("🔄 Removing teacher ID $teacherId from classroom ID $classroomId");
    try {
      await _service.removeTeacher(classroomId, teacherId);
      debugPrint("✅ Teacher ID $teacherId removed from classroom ID $classroomId");
      emit(AdminOperationSuccess('Teacher removed'));
      await getClassroomById(classroomId);
    } on DioException catch (e) {
      debugPrint("❌ Failed to remove teacher: ${_handleDioError(e)}");
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      debugPrint("❌ Failed to remove teacher: $e");
      emit(AdminOperationError('Failed to remove teacher'));
    }
  }

  Future<void> assignSubject(int classroomId, int subjectId, int teacherId) async {
    emit(AdminOperationLoading());
    debugPrint("🔄 Assigning subject ID $subjectId with teacher ID $teacherId to classroom ID $classroomId");
    try {
      await _service.assignSubject(classroomId, subjectId, teacherId);
      debugPrint("✅ Subject ID $subjectId assigned to classroom ID $classroomId");
      emit(AdminOperationSuccess('Subject assigned successfully'));
      await getClassroomById(classroomId);
    } on DioException catch (e) {
      debugPrint("❌ Failed to assign subject: ${_handleDioError(e)}");
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      debugPrint("❌ Failed to assign subject: $e");
      emit(AdminOperationError('Failed to assign subject'));
    }
  }

  Future<void> removeSubject(int classroomId, int subjectId) async {
    emit(AdminOperationLoading());
    debugPrint("🔄 Removing subject ID $subjectId from classroom ID $classroomId");
    try {
      await _service.removeSubject(classroomId, subjectId);
      debugPrint("✅ Subject ID $subjectId removed from classroom ID $classroomId");
      emit(AdminOperationSuccess('Subject removed'));
      await getClassroomById(classroomId);
    } on DioException catch (e) {
      debugPrint("❌ Failed to remove subject: ${_handleDioError(e)}");
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      debugPrint("❌ Failed to remove subject: $e");
      emit(AdminOperationError('Failed to remove subject'));
    }
  }

  // ═══════════════════════════════════════
  // SUBJECTS
  // ═══════════════════════════════════════
  Future<void> createSubject(Map<String, dynamic> data) async {
    emit(AdminOperationLoading());
    debugPrint("🔄 Creating subject: ${data['name']}");
    try {
      await _service.createSubject(data);
      debugPrint("✅ Subject created: ${data['name']}");
      emit(AdminOperationSuccess('Subject created successfully'));
      await loadDashboard();
    } on DioException catch (e) {
      debugPrint("❌ Failed to create subject: ${_handleDioError(e)}");
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      debugPrint("❌ Failed to create subject: $e");
      emit(AdminOperationError('Failed to create subject'));
    }
  }

  Future<void> getSubjectById(int id) async {
    emit(AdminLoading());
    debugPrint("🔄 Loading subject ID: $id");
    try {
      final subject = await _service.getSubjectById(id);
      debugPrint("✅ Subject loaded: ID $id");
      emit(SubjectLoaded(subject));
    } catch (e) {
      debugPrint("❌ Failed to load subject ID $id: $e");
      emit(AdminOperationError('Failed to load subject'));
    }
  }

  Future<void> getScheduleById(int id) async {
    emit(AdminLoading());
    debugPrint("🔄 Loading schedule ID: $id");
    try {
      final schedule = await _service.getScheduleById(id);
      debugPrint("✅ Schedule loaded: ID $id");
      emit(ScheduleLoaded(schedule));
    } catch (e) {
      debugPrint("❌ Failed to load schedule ID $id: $e");
      emit(AdminOperationError('Failed to load schedule'));
    }
  }

  Future<void> updateSubject(int id, Map<String, dynamic> data) async {
    emit(AdminOperationLoading());
    debugPrint("🔄 Updating subject ID: $id");
    try {
      await _service.updateSubject(id, data);
      debugPrint("✅ Subject updated: ID $id");
      emit(AdminOperationSuccess('Subject updated successfully'));
      await loadDashboard();
    } on DioException catch (e) {
      debugPrint("❌ Failed to update subject: ${_handleDioError(e)}");
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      debugPrint("❌ Failed to update subject: $e");
      emit(AdminOperationError('Failed to update subject'));
    }
  }

  Future<void> deleteSubject(int id) async {
    emit(AdminOperationLoading());
    debugPrint("🔄 Deleting subject ID: $id");
    try {
      await _service.deleteSubject(id);
      debugPrint("✅ Subject deleted: ID $id");
      emit(AdminOperationSuccess('Subject deleted successfully'));
      await loadDashboard();
    } on DioException catch (e) {
      debugPrint("❌ Failed to delete subject: ${_handleDioError(e)}");
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      debugPrint("❌ Failed to delete subject: $e");
      emit(AdminOperationError('Failed to delete subject'));
    }
  }

  // ═══════════════════════════════════════
  // SCHEDULES
  // ═══════════════════════════════════════
  Future<void> createSchedule(Map<String, dynamic> data) async {
    emit(AdminOperationLoading());
    debugPrint("🔄 Creating schedule for classroom ID ${data['classroom_id']}");
    try {
      await _service.createSchedule(data);
      debugPrint("✅ Schedule created for classroom ID ${data['classroom_id']}");
      emit(AdminOperationSuccess('Schedule created successfully'));
      await loadDashboard();
    } on DioException catch (e) {
      debugPrint("❌ Failed to create schedule: ${_handleDioError(e)}");
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      debugPrint("❌ Failed to create schedule: $e");
      emit(AdminOperationError('Failed to create schedule'));
    }
  }

  Future<void> updateSchedule(int id, Map<String, dynamic> data) async {
    emit(AdminOperationLoading());
    debugPrint("🔄 Updating schedule ID: $id");
    try {
      await _service.updateSchedule(id, data);
      debugPrint("✅ Schedule updated: ID $id");
      emit(AdminOperationSuccess('Schedule updated successfully'));
      await loadDashboard();
    } on DioException catch (e) {
      debugPrint("❌ Failed to update schedule: ${_handleDioError(e)}");
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      debugPrint("❌ Failed to update schedule: $e");
      emit(AdminOperationError('Failed to update schedule'));
    }
  }

  Future<void> deleteSchedule(int id) async {
    emit(AdminOperationLoading());
    debugPrint("🔄 Deleting schedule ID: $id");
    try {
      await _service.deleteSchedule(id);
      debugPrint("✅ Schedule deleted: ID $id");
      emit(AdminOperationSuccess('Schedule deleted successfully'));
      await loadDashboard();
    } on DioException catch (e) {
      debugPrint("❌ Failed to delete schedule: ${_handleDioError(e)}");
      emit(AdminOperationError(_handleDioError(e)));
    } catch (e) {
      debugPrint("❌ Failed to delete schedule: $e");
      emit(AdminOperationError('Failed to delete schedule'));
    }
  }

  // ═══════════════════════════════════════
  // USER DETAILS
  // ═══════════════════════════════════════
  Future<void> loadUserDetails(int userId, String role) async {
    emit(AdminUserDetailsLoading());
    debugPrint("🔄 Loading user details for ID $userId (role: $role)");
    try {
      final user = await _service.getUserById(userId);
      AdminStudentModel? student;
      AdminTeacherModel? teacher;
      AdminParentModel? parent;

      if (role == 'student') {
        final students = await _service.getStudents();
        student = students.firstWhere(
          (s) => s.userId == userId,
          orElse: () => throw Exception('Student not found'),
        );
        debugPrint("✅ Student details loaded for user ID $userId");
      } else if (role == 'teacher') {
        final teachers = await _service.getTeachers();
        teacher = teachers.firstWhere(
          (t) => t.userId == userId,
          orElse: () => throw Exception('Teacher not found'),
        );
        debugPrint("✅ Teacher details loaded for user ID $userId");
      } else if (role == 'parent') {
        final parents = await _service.getParents();
        parent = parents.firstWhere(
          (p) => p.userId == userId,
          orElse: () => throw Exception('Parent not found'),
        );
        debugPrint("✅ Parent details loaded for user ID $userId");
      }

      emit(
        AdminUserDetailsLoaded(
          user: user,
          student: student,
          teacher: teacher,
          parent: parent,
        ),
      );
    } on DioException catch (e) {
      debugPrint("❌ Failed to load user details: ${_handleDioError(e)}");
      emit(AdminUserDetailsError(_handleDioError(e)));
    } catch (e) {
      debugPrint("❌ Failed to load user details: $e");
      emit(AdminUserDetailsError('Failed to load user details'));
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
        break;
    }
    return e.message ?? 'Something went wrong';
  }
}