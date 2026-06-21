import 'package:bloc/bloc.dart';
import 'package:dio/src/form_data.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:school_test/features/teacher/data/models/teacher_assignment_model.dart';
import 'package:school_test/features/teacher/data/models/teacher_attendance_model.dart';
import 'package:school_test/features/teacher/data/models/teacher_classroom_model.dart';
import 'package:school_test/features/teacher/data/models/teacher_exam_model.dart';
import 'package:school_test/features/teacher/data/models/teacher_grade_model.dart';
import 'package:school_test/features/teacher/data/models/teacher_message_model.dart';
import 'package:school_test/features/teacher/data/models/teacher_notification_model.dart';
import 'package:school_test/features/teacher/data/models/teacher_resource_model.dart';
import 'package:school_test/features/teacher/data/models/teacher_student_model.dart';
import 'package:school_test/features/teacher/data/models/teacher_submission_model.dart';
import 'package:school_test/features/teacher/data/teacher_service.dart';

part 'teacher_state.dart';

class TeacherCubit extends Cubit<TeacherState> {
  final TeacherService _service;
  int? _teacherId;

  TeacherCubit(this._service) : super(TeacherInitial());

  int get teacherId => _teacherId ?? 0;

  TeacherLoaded? get _loaded =>
      state is TeacherLoaded ? state as TeacherLoaded : null;

  void _safeEmit(TeacherState s) {
    debugPrint('📤 [_safeEmit] Emitting state: ${s.runtimeType}');
    if (!isClosed) emit(s);
  }

  // ═══ LOAD DASHBOARD ═══
  Future<void> loadDashboard(int teacherId) async {
    debugPrint('🔄 [loadDashboard] Started loading teacher dashboard...');
    _safeEmit(TeacherLoading());
    try {
      int realId = teacherId;
      if (realId == 0) {
        debugPrint('📥 [loadDashboard] Fetching teacher ID from service...');
        realId = await _service.getMyTeacherId();
        debugPrint('✅ [loadDashboard] Teacher ID received: $realId');
      }
      _teacherId = realId;

      debugPrint('📥 [loadDashboard] Fetching profile...');
      final profile = await _service.getMyProfile();
      debugPrint('✅ [loadDashboard] Profile loaded: ${profile.name}');

      debugPrint('📥 [loadDashboard] Fetching classrooms...');
      final classrooms = await _service.getMyClassrooms();
      debugPrint('✅ [loadDashboard] Classrooms loaded: ${classrooms.length}');

      debugPrint('📥 [loadDashboard] Fetching students...');
      final students = await _service.getMyStudents();
      debugPrint('✅ [loadDashboard] Students loaded: ${students.length}');

      debugPrint('📥 [loadDashboard] Fetching messages...');
      final messages = await _service.getMessages();
      debugPrint('✅ [loadDashboard] Messages loaded: ${messages.length}');

      debugPrint('📥 [loadDashboard] Fetching assignments...');
      final assignments = await _service.getMyAssignments();
      debugPrint('✅ [loadDashboard] Assignments loaded: ${assignments.length}');

      debugPrint('📥 [loadDashboard] Fetching exams...');
      final exams = await _service.getMyExams();
      debugPrint('✅ [loadDashboard] Exams loaded: ${exams.length}');

      debugPrint('📥 [loadDashboard] Fetching grades...');
      final grades = await _service.getMyGrades();
      debugPrint('✅ [loadDashboard] Grades loaded: ${grades.length}');

      debugPrint('📥 [loadDashboard] Fetching unread message count...');
      final unreadMessages = await _service.getUnreadMessageCount();
      debugPrint('✅ [loadDashboard] Unread messages: $unreadMessages');

      debugPrint('📥 [loadDashboard] Fetching unread notification count...');
      final unreadNotifications = await _service.getUnreadNotificationCount();
      debugPrint(
        '✅ [loadDashboard] Unread notifications: $unreadNotifications',
      );

      debugPrint(
        '📊 [loadDashboard] Data summary: '
        'classrooms=${classrooms.length}, students=${students.length}, '
        'messages=${messages.length}, assignments=${assignments.length}, '
        'exams=${exams.length}, grades=${grades.length}',
      );

      _safeEmit(
        TeacherLoaded(
          classrooms: classrooms,
          students: students,
          messages: messages,
          assignments: assignments,
          exams: exams,
          grades: grades,
          unreadMessageCount: unreadMessages,
          unreadNotificationCount: unreadNotifications,
          totalStudents: students.length,
          teacherUserId: profile.id,
          teacherName: profile.name,
          teacherRole: profile.role,
        ),
      );
      debugPrint('✅ [loadDashboard] Teacher dashboard loaded successfully');
    } catch (e, stack) {
      debugPrint('❌ [loadDashboard] Error loading teacher dashboard: $e');
      debugPrint('📚 [loadDashboard] Stack trace: $stack');
      _safeEmit(TeacherError(e.toString()));
    }
  }

  Future<void> refreshDashboard() {
    debugPrint('🔄 [refreshDashboard] Refreshing dashboard...');
    return loadDashboard(_teacherId ?? 0);
  }

  // ═══ ASSIGNMENTS ═══
  Future<void> createAssignment(Map<String, dynamic> data) async {
    debugPrint('📝 [createAssignment] Creating new assignment...');
    final prev = _loaded;
    _safeEmit(TeacherOperationLoading());
    try {
      await _service.createAssignment(data);
      debugPrint('✅ [createAssignment] Assignment created successfully');
      final updated = await _service.getMyAssignments();
      debugPrint(
        '📊 [createAssignment] Updated assignments count: ${updated.length}',
      );
      _safeEmit(TeacherOperationSuccess('Assignment created'));
      if (prev != null) _safeEmit(prev.copyWith(assignments: updated));
    } catch (e) {
      debugPrint('❌ [createAssignment] Error: $e');
      _safeEmit(TeacherOperationError(e.toString()));
      if (prev != null) _safeEmit(prev);
    }
  }

  Future<void> updateAssignment(int id, Map<String, dynamic> data) async {
    debugPrint('📝 [updateAssignment] Updating assignment ID: $id');
    final prev = _loaded;
    _safeEmit(TeacherOperationLoading());
    try {
      await _service.updateAssignment(id, data);
      debugPrint('✅ [updateAssignment] Assignment updated successfully');
      final updated = await _service.getMyAssignments();
      debugPrint(
        '📊 [updateAssignment] Updated assignments count: ${updated.length}',
      );
      _safeEmit(TeacherOperationSuccess('Assignment updated'));
      if (prev != null) _safeEmit(prev.copyWith(assignments: updated));
    } catch (e) {
      debugPrint('❌ [updateAssignment] Error: $e');
      _safeEmit(TeacherOperationError(e.toString()));
      if (prev != null) _safeEmit(prev);
    }
  }

  Future<void> deleteAssignment(int id) async {
    debugPrint('🗑️ [deleteAssignment] Deleting assignment ID: $id');
    final prev = _loaded;
    _safeEmit(TeacherOperationLoading());
    try {
      await _service.deleteAssignment(id);
      debugPrint('✅ [deleteAssignment] Assignment deleted successfully');
      final updated = await _service.getMyAssignments();
      debugPrint(
        '📊 [deleteAssignment] Updated assignments count: ${updated.length}',
      );
      _safeEmit(TeacherOperationSuccess('Assignment deleted'));
      if (prev != null) _safeEmit(prev.copyWith(assignments: updated));
    } catch (e) {
      debugPrint('❌ [deleteAssignment] Error: $e');
      _safeEmit(TeacherOperationError(e.toString()));
      if (prev != null) _safeEmit(prev);
    }
  }

  // ═══ GRADING ═══
  Future<void> gradeSubmission(
    int submissionId, {
    required int score,
    required String feedback,
  }) async {
    debugPrint(
      '📊 [gradeSubmission] Grading submission ID: $submissionId, score: $score',
    );
    final prev = _loaded;
    _safeEmit(TeacherOperationLoading());
    try {
      await _service.gradeSubmission(
        submissionId,
        score: score,
        feedback: feedback,
      );
      debugPrint('✅ [gradeSubmission] Submission graded successfully');
      final updatedSubmissions = await _service.getMySubmissions();
      debugPrint(
        '📊 [gradeSubmission] Updated submissions count: ${updatedSubmissions.length}',
      );
      _safeEmit(TeacherOperationSuccess('Submission graded'));
      if (prev != null)
        _safeEmit(prev.copyWith(submissions: updatedSubmissions));
    } catch (e) {
      debugPrint('❌ [gradeSubmission] Error: $e');
      _safeEmit(TeacherOperationError(e.toString()));
      if (prev != null) _safeEmit(prev);
    }
  }

  Future<void> updateSubmissionGrade(
    int submissionId, {
    required int score,
    required String feedback,
  }) async {
    debugPrint(
      '📊 [updateSubmissionGrade] Updating grade for submission ID: $submissionId, score: $score',
    );
    final prev = _loaded;
    _safeEmit(TeacherOperationLoading());
    try {
      await _service.updateSubmissionGrade(
        submissionId,
        score: score,
        feedback: feedback,
      );
      debugPrint('✅ [updateSubmissionGrade] Grade updated successfully');
      final updated = await _service.getMySubmissions();
      debugPrint(
        '📊 [updateSubmissionGrade] Updated submissions count: ${updated.length}',
      );
      _safeEmit(TeacherOperationSuccess('Grade updated'));
      if (prev != null) _safeEmit(prev.copyWith(submissions: updated));
    } catch (e) {
      debugPrint('❌ [updateSubmissionGrade] Error: $e');
      _safeEmit(TeacherOperationError(e.toString()));
      if (prev != null) _safeEmit(prev);
    }
  }

  // ═══ GRADES ═══
  Future<void> createGrade(Map<String, dynamic> data) async {
    debugPrint('📊 [createGrade] Creating new grade...');
    final prev = _loaded;
    _safeEmit(TeacherOperationLoading());
    try {
      await _service.createGrade(data);
      debugPrint('✅ [createGrade] Grade created successfully');
      final updated = await _service.getMyGrades();
      debugPrint('📊 [createGrade] Updated grades count: ${updated.length}');
      _safeEmit(TeacherOperationSuccess('Grade recorded'));
      if (prev != null) _safeEmit(prev.copyWith(grades: updated));
    } catch (e) {
      debugPrint('❌ [createGrade] Error: $e');
      _safeEmit(TeacherOperationError(e.toString()));
      if (prev != null) _safeEmit(prev);
    }
  }

  Future<void> deleteGrade(int gradeId) async {
    debugPrint('🗑️ [deleteGrade] Deleting grade ID: $gradeId');
    final prev = _loaded;
    _safeEmit(TeacherOperationLoading());
    try {
      await _service.deleteGrade(gradeId);
      debugPrint('✅ [deleteGrade] Grade deleted successfully');
      final updated = await _service.getMyGrades();
      debugPrint('📊 [deleteGrade] Updated grades count: ${updated.length}');
      _safeEmit(TeacherOperationSuccess('Grade deleted'));
      if (prev != null) _safeEmit(prev.copyWith(grades: updated));
    } catch (e) {
      debugPrint('❌ [deleteGrade] Error: $e');
      _safeEmit(TeacherOperationError(e.toString()));
      if (prev != null) _safeEmit(prev);
    }
  }

  // ═══ ATTENDANCE ═══
  Future<void> recordAttendance(Map<String, dynamic> data) async {
    debugPrint('📋 [recordAttendance] Recording attendance...');
    final prev = _loaded;
    _safeEmit(TeacherOperationLoading());
    try {
      await _service.recordAttendance(data);
      debugPrint('✅ [recordAttendance] Attendance recorded successfully');
      final updated = await _service.getMyAttendance();
      debugPrint(
        '📊 [recordAttendance] Updated attendance count: ${updated.length}',
      );
      _safeEmit(TeacherOperationSuccess('Attendance recorded'));
      if (prev != null) _safeEmit(prev.copyWith(attendances: updated));
    } catch (e) {
      debugPrint('❌ [recordAttendance] Error: $e');
      _safeEmit(TeacherOperationError(e.toString()));
      if (prev != null) _safeEmit(prev);
    }
  }

  Future<void> updateAttendance(int id, Map<String, dynamic> data) async {
    debugPrint('📋 [updateAttendance] Updating attendance ID: $id');
    final prev = _loaded;
    _safeEmit(TeacherOperationLoading());
    try {
      await _service.updateAttendance(id, data);
      debugPrint('✅ [updateAttendance] Attendance updated successfully');
      final updated = await _service.getMyAttendance();
      debugPrint(
        '📊 [updateAttendance] Updated attendance count: ${updated.length}',
      );
      _safeEmit(TeacherOperationSuccess('Attendance updated'));
      if (prev != null) _safeEmit(prev.copyWith(attendances: updated));
    } catch (e) {
      debugPrint('❌ [updateAttendance] Error: $e');
      _safeEmit(TeacherOperationError(e.toString()));
      if (prev != null) _safeEmit(prev);
    }
  }

  Future<void> deleteAttendance(int id) async {
    debugPrint('🗑️ [deleteAttendance] Deleting attendance ID: $id');
    final prev = _loaded;
    _safeEmit(TeacherOperationLoading());
    try {
      await _service.deleteAttendance(id);
      debugPrint('✅ [deleteAttendance] Attendance deleted successfully');
      final updated = await _service.getMyAttendance();
      debugPrint(
        '📊 [deleteAttendance] Updated attendance count: ${updated.length}',
      );
      _safeEmit(TeacherOperationSuccess('Attendance deleted'));
      if (prev != null) _safeEmit(prev.copyWith(attendances: updated));
    } catch (e) {
      debugPrint('❌ [deleteAttendance] Error: $e');
      _safeEmit(TeacherOperationError(e.toString()));
      if (prev != null) _safeEmit(prev);
    }
  }

  // ═══ EXAMS ═══
  Future<void> createExam(Map<String, dynamic> data) async {
    debugPrint('📝 [createExam] Creating new exam...');
    final prev = _loaded;
    _safeEmit(TeacherOperationLoading());
    try {
      await _service.createExam(data);
      debugPrint('✅ [createExam] Exam created successfully');
      final updated = await _service.getMyExams();
      debugPrint('📊 [createExam] Updated exams count: ${updated.length}');
      _safeEmit(TeacherOperationSuccess('Exam created'));
      if (prev != null) _safeEmit(prev.copyWith(exams: updated));
    } catch (e) {
      debugPrint('❌ [createExam] Error: $e');
      _safeEmit(TeacherOperationError(e.toString()));
      if (prev != null) _safeEmit(prev);
    }
  }

  Future<void> updateExam(int id, Map<String, dynamic> data) async {
    debugPrint('📝 [updateExam] Updating exam ID: $id');
    final prev = _loaded;
    _safeEmit(TeacherOperationLoading());
    try {
      await _service.updateExam(id, data);
      debugPrint('✅ [updateExam] Exam updated successfully');
      final updated = await _service.getMyExams();
      debugPrint('📊 [updateExam] Updated exams count: ${updated.length}');
      _safeEmit(TeacherOperationSuccess('Exam updated'));
      if (prev != null) _safeEmit(prev.copyWith(exams: updated));
    } catch (e) {
      debugPrint('❌ [updateExam] Error: $e');
      _safeEmit(TeacherOperationError(e.toString()));
      if (prev != null) _safeEmit(prev);
    }
  }

  Future<void> deleteExam(int id) async {
    debugPrint('🗑️ [deleteExam] Deleting exam ID: $id');
    final prev = _loaded;
    _safeEmit(TeacherOperationLoading());
    try {
      await _service.deleteExam(id);
      debugPrint('✅ [deleteExam] Exam deleted successfully');
      final updated = await _service.getMyExams();
      debugPrint('📊 [deleteExam] Updated exams count: ${updated.length}');
      _safeEmit(TeacherOperationSuccess('Exam deleted'));
      if (prev != null) _safeEmit(prev.copyWith(exams: updated));
    } catch (e) {
      debugPrint('❌ [deleteExam] Error: $e');
      _safeEmit(TeacherOperationError(e.toString()));
      if (prev != null) _safeEmit(prev);
    }
  }

  // ═══ MESSAGES ═══
  Future<void> sendMessage({
    required int receiverId,
    int? studentId,
    required String subject,
    required String content,
    required String type,
  }) async {
    debugPrint(
      '💬 [sendMessage] Sending message to receiver: $receiverId, subject: $subject',
    );
    final prev = _loaded;
    _safeEmit(TeacherOperationLoading());
    try {
      await _service.sendMessage(
        receiverId: receiverId,
        studentId: studentId,
        subject: subject,
        content: content,
        type: type,
      );
      debugPrint('✅ [sendMessage] Message sent successfully');
      final updatedMessages = await _service.getMessages();
      final unreadCount = await _service.getUnreadMessageCount();
      debugPrint(
        '📊 [sendMessage] Updated messages count: ${updatedMessages.length}, unread: $unreadCount',
      );
      _safeEmit(TeacherOperationSuccess('Message sent'));
      if (prev != null) {
        _safeEmit(
          prev.copyWith(
            messages: updatedMessages,
            unreadMessageCount: unreadCount,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ [sendMessage] Error: $e');
      _safeEmit(TeacherOperationError(e.toString()));
      if (prev != null) _safeEmit(prev);
    }
  }

  // ═══ NOTIFICATIONS ═══
  Future<void> markNotificationRead(int id) async {
    debugPrint(
      '🔔 [markNotificationRead] Marking notification ID: $id as read',
    );
    final prev = _loaded;
    try {
      await _service.markNotificationRead(id);
      debugPrint('✅ [markNotificationRead] Notification marked as read');
      final updated = await _service.getMyNotifications();
      final unreadCount = await _service.getUnreadNotificationCount();
      debugPrint(
        '📊 [markNotificationRead] Updated notifications count: ${updated.length}, unread: $unreadCount',
      );
      if (prev != null) {
        _safeEmit(
          prev.copyWith(
            notifications: updated,
            unreadNotificationCount: unreadCount,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ [markNotificationRead] Error: $e');
      _safeEmit(TeacherOperationError(e.toString()));
      if (prev != null) _safeEmit(prev);
    }
  }

  Future<void> markAllNotificationsRead() async {
    debugPrint(
      '🔔 [markAllNotificationsRead] Marking all notifications as read',
    );
    final prev = _loaded;
    try {
      await _service.markAllNotificationsRead();
      debugPrint(
        '✅ [markAllNotificationsRead] All notifications marked as read',
      );
      final updated = await _service.getMyNotifications();
      debugPrint(
        '📊 [markAllNotificationsRead] Updated notifications count: ${updated.length}',
      );
      if (prev != null) {
        _safeEmit(
          prev.copyWith(notifications: updated, unreadNotificationCount: 0),
        );
      }
    } catch (e) {
      debugPrint('❌ [markAllNotificationsRead] Error: $e');
      _safeEmit(TeacherOperationError(e.toString()));
      if (prev != null) _safeEmit(prev);
    }
  }

  Future<void> deleteNotification(int id) async {
    debugPrint('🗑️ [deleteNotification] Deleting notification ID: $id');
    final prev = _loaded;
    try {
      await _service.deleteNotification(id);
      debugPrint('✅ [deleteNotification] Notification deleted successfully');
      final updated = await _service.getMyNotifications();
      final unreadCount = await _service.getUnreadNotificationCount();
      debugPrint(
        '📊 [deleteNotification] Updated notifications count: ${updated.length}, unread: $unreadCount',
      );
      if (prev != null) {
        _safeEmit(
          prev.copyWith(
            notifications: updated,
            unreadNotificationCount: unreadCount,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ [deleteNotification] Error: $e');
      _safeEmit(TeacherOperationError(e.toString()));
      if (prev != null) _safeEmit(prev);
    }
  }

  // ═══ RESOURCES ═══
  Future<void> createResource(Map<String, dynamic> data) async {
    debugPrint('📁 [createResource] Creating new resource...');
    final prev = _loaded;
    _safeEmit(TeacherOperationLoading());
    try {
      await _service.createResource(data as FormData);
      debugPrint('✅ [createResource] Resource created successfully');
      final updated = await _service.getMyResources();
      debugPrint(
        '📊 [createResource] Updated resources count: ${updated.length}',
      );
      _safeEmit(TeacherOperationSuccess('Resource created'));
      if (prev != null) _safeEmit(prev.copyWith(resources: updated));
    } catch (e) {
      debugPrint('❌ [createResource] Error: $e');
      _safeEmit(TeacherOperationError(e.toString()));
      if (prev != null) _safeEmit(prev);
    }
  }

  Future<void> deleteResource(int id) async {
    debugPrint('🗑️ [deleteResource] Deleting resource ID: $id');
    final prev = _loaded;
    _safeEmit(TeacherOperationLoading());
    try {
      await _service.deleteResource(id);
      debugPrint('✅ [deleteResource] Resource deleted successfully');
      final updated = await _service.getMyResources();
      debugPrint(
        '📊 [deleteResource] Updated resources count: ${updated.length}',
      );
      _safeEmit(TeacherOperationSuccess('Resource deleted'));
      if (prev != null) _safeEmit(prev.copyWith(resources: updated));
    } catch (e) {
      debugPrint('❌ [deleteResource] Error: $e');
      _safeEmit(TeacherOperationError(e.toString()));
      if (prev != null) _safeEmit(prev);
    }
  }

  // ═══ HELPERS ═══
  Future<List<Map<String, dynamic>>> getAvailableParents({String? search}) {
    debugPrint(
      '🔍 [getAvailableParents] Searching parents with query: $search',
    );
    return _service.getAvailableParents(search: search);
  }

  Future<List<TeacherSubmissionModel>> getAssignmentSubmissions(
    int assignmentId,
  ) {
    debugPrint(
      '📥 [getAssignmentSubmissions] Fetching submissions for assignment ID: $assignmentId',
    );
    return _service.getAssignmentSubmissions(assignmentId);
  }

  Future<List<TeacherGradeModel>> getStudentGrades(int studentId) {
    debugPrint(
      '📥 [getStudentGrades] Fetching grades for student ID: $studentId',
    );
    return _service.getStudentGrades(studentId);
  }

  Future<Map<String, dynamic>> getClassroomAttendanceSummary(int classroomId) {
    debugPrint(
      '📥 [getClassroomAttendanceSummary] Fetching attendance summary for classroom ID: $classroomId',
    );
    return _service.getClassroomAttendanceSummary(classroomId);
  }

  Future<Map<String, dynamic>> getStudentAttendanceSummary(int studentId) {
    debugPrint(
      '📥 [getStudentAttendanceSummary] Fetching attendance summary for student ID: $studentId',
    );
    return _service.getStudentAttendanceSummary(studentId);
  }

  Future<List<TeacherGradeModel>> getExamResults(int examId) {
    debugPrint('📥 [getExamResults] Fetching results for exam ID: $examId');
    return _service.getExamResults(examId);
  }
}
