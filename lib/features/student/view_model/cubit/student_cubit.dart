import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:school_test/features/student/data/models/student_teacher_model.dart';
import 'package:school_test/features/student/data/student_service.dart';
import 'package:school_test/features/student/data/models/student_profile_model.dart';
import 'package:school_test/features/student/data/models/student_dashboard_model.dart';
import 'package:school_test/features/student/data/models/student_schedule_model.dart';
import 'package:school_test/features/student/data/models/student_grade_model.dart';
import 'package:school_test/features/student/data/models/student_exam_model.dart';
import 'package:school_test/features/student/data/models/student_subject_model.dart';
import 'package:school_test/features/student/data/models/student_classroom_model.dart';
import 'package:school_test/features/student/data/models/student_assignment_model.dart';
import 'package:school_test/features/student/data/models/student_submission_model.dart';
import 'package:school_test/features/student/data/models/student_attendance_model.dart';
import 'package:school_test/features/student/data/models/student_resource_model.dart';

part 'student_state.dart';

class StudentCubit extends Cubit<StudentState> {
  final StudentService _service;
  StudentCubit(this._service) : super(StudentInitial());

  // ─── Load All Data ────────────────────────────────────
  Future<void> loadDashboard() async {
    if (state is StudentLoading) return;
    _safeEmit(StudentLoading());
    debugPrint('🔄 [loadDashboard] Started loading student dashboard...');

    try {
      debugPrint('📥 [loadDashboard] Fetching profile...');
      final profile = await _service.getProfile();
      debugPrint('✅ [loadDashboard] Profile loaded: ${profile.name} (ID: ${profile.id})');

      debugPrint('📥 [loadDashboard] Fetching dashboard...');
      final dashboard = await _service.getDashboard();
      debugPrint('✅ [loadDashboard] Dashboard loaded: subjects=${dashboard.subjectsCount}, avg=${dashboard.averageScore}');

      debugPrint('📥 [loadDashboard] Fetching schedule...');
      final schedule = await _service.getSchedule();
      debugPrint('✅ [loadDashboard] Schedule loaded: ${schedule.length} items');

      debugPrint('📥 [loadDashboard] Fetching grades...');
      final grades = await _service.getGrades();
      debugPrint('✅ [loadDashboard] Grades loaded: ${grades.length} items');

      debugPrint('📥 [loadDashboard] Fetching exams...');
      final exams = await _service.getExams();
      debugPrint('✅ [loadDashboard] Exams loaded: ${exams.length} items');

      debugPrint('📥 [loadDashboard] Fetching subjects...');
      final subjects = await _service.getSubjects();
      debugPrint('✅ [loadDashboard] Subjects loaded: ${subjects.length} items');

      debugPrint('📥 [loadDashboard] Fetching teachers...');
      final teachers = await _service.getTeachers();
      debugPrint('✅ [loadDashboard] Teachers loaded: ${teachers.length} items');

      debugPrint('📥 [loadDashboard] Fetching assignments...');
      final assignments = await _service.getAssignments();
      debugPrint('✅ [loadDashboard] Assignments loaded: ${assignments.length} items');

      debugPrint('📥 [loadDashboard] Fetching submissions...');
      final submissions = await _service.getSubmissions();
      debugPrint('✅ [loadDashboard] Submissions loaded: ${submissions.length} items');

      debugPrint('📥 [loadDashboard] Fetching attendance records...');
      final attendances = await _service.getAttendance();
      debugPrint('✅ [loadDashboard] Attendance records loaded: ${attendances.length} items');

      debugPrint('📥 [loadDashboard] Fetching attendance summary...');
      final attendanceSummary = await _service.getAttendanceSummary();
      debugPrint('✅ [loadDashboard] Attendance summary loaded: rate=${attendanceSummary.attendanceRate}');

      final classroom = profile.classrooms.isNotEmpty
          ? profile.classrooms.first
          : StudentClassroomModel(
              id: 0,
              name: '',
              gradeLevel: '',
              capacity: 0,
              academicYear: '',
              subjects: const [],
              teachers: const [],
            );
      debugPrint('✅ [loadDashboard] Classroom selected: ${classroom.name} (ID: ${classroom.id})');

      _safeEmit(StudentLoaded(
        profile: profile,
        dashboard: dashboard,
        schedule: schedule,
        grades: grades,
        exams: exams,
        subjects: subjects,
        classroom: classroom,
        teachers: teachers,
        assignments: assignments,
        submissions: submissions,
        attendances: attendances,
        attendanceSummary: attendanceSummary,
      ));
      debugPrint('✅ [loadDashboard] Student dashboard loaded successfully');
    } catch (e, stack) {
      debugPrint('❌ [loadDashboard] Error loading student dashboard: $e');
      debugPrint('📚 [loadDashboard] Stack trace: $stack');
      _safeEmit(StudentError(_handleError(e)));
    }
  }

  // ─── Individual Refreshes ─────────────────────────────
  Future<void> getProfile() async {
    debugPrint('🔄 [getProfile] Refreshing profile...');
    try {
      final profile = await _service.getProfile();
      if (state is StudentLoaded) {
        _safeEmit((state as StudentLoaded).copyWith(profile: profile));
        debugPrint('✅ [getProfile] Profile refreshed: ${profile.name}');
      } else {
        debugPrint('⚠️ [getProfile] State is not StudentLoaded, skipping update.');
      }
    } catch (e) {
      debugPrint('❌ [getProfile] Error refreshing profile: $e');
      _safeEmit(StudentOperationError(_handleError(e)));
    }
  }

  Future<void> getSchedule() async {
    debugPrint('🔄 [getSchedule] Refreshing schedule...');
    try {
      final schedule = await _service.getSchedule();
      if (state is StudentLoaded) {
        _safeEmit((state as StudentLoaded).copyWith(schedule: schedule));
        debugPrint('✅ [getSchedule] Schedule refreshed: ${schedule.length} items');
      } else {
        debugPrint('⚠️ [getSchedule] State is not StudentLoaded, skipping update.');
      }
    } catch (e) {
      debugPrint('❌ [getSchedule] Error refreshing schedule: $e');
      _safeEmit(StudentOperationError(_handleError(e)));
    }
  }

  Future<void> getGrades() async {
    debugPrint('🔄 [getGrades] Refreshing grades...');
    try {
      final grades = await _service.getGrades();
      if (state is StudentLoaded) {
        _safeEmit((state as StudentLoaded).copyWith(grades: grades));
        debugPrint('✅ [getGrades] Grades refreshed: ${grades.length} items');
      } else {
        debugPrint('⚠️ [getGrades] State is not StudentLoaded, skipping update.');
      }
    } catch (e) {
      debugPrint('❌ [getGrades] Error refreshing grades: $e');
      _safeEmit(StudentOperationError(_handleError(e)));
    }
  }

  Future<void> getExams() async {
    debugPrint('🔄 [getExams] Refreshing exams...');
    try {
      final exams = await _service.getExams();
      if (state is StudentLoaded) {
        _safeEmit((state as StudentLoaded).copyWith(exams: exams));
        debugPrint('✅ [getExams] Exams refreshed: ${exams.length} items');
      } else {
        debugPrint('⚠️ [getExams] State is not StudentLoaded, skipping update.');
      }
    } catch (e) {
      debugPrint('❌ [getExams] Error refreshing exams: $e');
      _safeEmit(StudentOperationError(_handleError(e)));
    }
  }

  Future<void> getSubjects() async {
    debugPrint('🔄 [getSubjects] Refreshing subjects...');
    try {
      final subjects = await _service.getSubjects();
      if (state is StudentLoaded) {
        _safeEmit((state as StudentLoaded).copyWith(subjects: subjects));
        debugPrint('✅ [getSubjects] Subjects refreshed: ${subjects.length} items');
      } else {
        debugPrint('⚠️ [getSubjects] State is not StudentLoaded, skipping update.');
      }
    } catch (e) {
      debugPrint('❌ [getSubjects] Error refreshing subjects: $e');
      _safeEmit(StudentOperationError(_handleError(e)));
    }
  }

  Future<void> getTeachers() async {
    debugPrint('🔄 [getTeachers] Refreshing teachers...');
    try {
      final teachers = await _service.getTeachers();
      if (state is StudentLoaded) {
        _safeEmit((state as StudentLoaded).copyWith(teachers: teachers));
        debugPrint('✅ [getTeachers] Teachers refreshed: ${teachers.length} items');
      } else {
        debugPrint('⚠️ [getTeachers] State is not StudentLoaded, skipping update.');
      }
    } catch (e) {
      debugPrint('❌ [getTeachers] Error refreshing teachers: $e');
      _safeEmit(StudentOperationError(_handleError(e)));
    }
  }

  Future<void> getAssignments() async {
    debugPrint('🔄 [getAssignments] Refreshing assignments...');
    try {
      final assignments = await _service.getAssignments();
      if (state is StudentLoaded) {
        _safeEmit((state as StudentLoaded).copyWith(assignments: assignments));
        debugPrint('✅ [getAssignments] Assignments refreshed: ${assignments.length} items');
      } else {
        debugPrint('⚠️ [getAssignments] State is not StudentLoaded, skipping update.');
      }
    } catch (e) {
      debugPrint('❌ [getAssignments] Error refreshing assignments: $e');
      _safeEmit(StudentOperationError(_handleError(e)));
    }
  }

  Future<void> getSubmissions() async {
    debugPrint('🔄 [getSubmissions] Refreshing submissions...');
    try {
      final submissions = await _service.getSubmissions();
      if (state is StudentLoaded) {
        _safeEmit((state as StudentLoaded).copyWith(submissions: submissions));
        debugPrint('✅ [getSubmissions] Submissions refreshed: ${submissions.length} items');
      } else {
        debugPrint('⚠️ [getSubmissions] State is not StudentLoaded, skipping update.');
      }
    } catch (e) {
      debugPrint('❌ [getSubmissions] Error refreshing submissions: $e');
      _safeEmit(StudentOperationError(_handleError(e)));
    }
  }

  Future<void> getAttendance() async {
    debugPrint('🔄 [getAttendance] Refreshing attendance...');
    try {
      final attendances = await _service.getAttendance();
      final summary = await _service.getAttendanceSummary();
      if (state is StudentLoaded) {
        _safeEmit((state as StudentLoaded).copyWith(
          attendances: attendances,
          attendanceSummary: summary,
        ));
        debugPrint('✅ [getAttendance] Attendance refreshed: ${attendances.length} records, rate=${summary.attendanceRate}');
      } else {
        debugPrint('⚠️ [getAttendance] State is not StudentLoaded, skipping update.');
      }
    } catch (e) {
      debugPrint('❌ [getAttendance] Error refreshing attendance: $e');
      _safeEmit(StudentOperationError(_handleError(e)));
    }
  }

  Future<void> getResources({int? subjectId, String? type, String? search}) async {
    debugPrint('🔄 [getResources] Fetching resources (subjectId: $subjectId, type: $type, search: $search)...');
    try {
      final resources = await _service.getResources(
        subjectId: subjectId,
        type: type,
        search: search,
      );
      if (state is StudentLoaded) {
        _safeEmit((state as StudentLoaded).copyWith(resources: resources));
        debugPrint('✅ [getResources] Resources fetched: ${resources.length} items');
      } else {
        debugPrint('⚠️ [getResources] State is not StudentLoaded, skipping update.');
      }
    } catch (e) {
      debugPrint('❌ [getResources] Error fetching resources: $e');
      _safeEmit(StudentOperationError(_handleError(e)));
    }
  }

  // ─── Assignment Submission ────────────────────────────
  Future<void> submitAssignment(int assignmentId, Map<String, dynamic> data) async {
    debugPrint('📤 [submitAssignment] Submitting assignment $assignmentId with data: $data');
    _safeEmit(StudentOperationLoading());
    try {
      await _service.submitAssignment(assignmentId, data);
      debugPrint('✅ [submitAssignment] Assignment $assignmentId submitted successfully');
      _safeEmit(StudentOperationSuccess('Assignment submitted successfully'));
      await getAssignments();
      await getSubmissions();
      debugPrint('✅ [submitAssignment] Refresh completed after submission.');
    } on DioException catch (e) {
      debugPrint('❌ [submitAssignment] DioException: ${e.message} (status: ${e.response?.statusCode})');
      _safeEmit(StudentOperationError(_handleDioError(e)));
    } catch (e) {
      debugPrint('❌ [submitAssignment] Unexpected error: $e');
      _safeEmit(StudentOperationError(_handleError(e)));
    }
  }

  // ─── Error Handling ───────────────────────────────────
  String _handleDioError(DioException e) {
    debugPrint('⚠️ [_handleDioError] Processing DioException: ${e.type}');
    switch (e.response?.statusCode) {
      case 400: 
        debugPrint('🛑 [_handleDioError] Bad request (400)');
        return 'Bad request';
      case 401: 
        debugPrint('🛑 [_handleDioError] Unauthorized (401)');
        return 'Unauthorized - please login again';
      case 403: 
        debugPrint('🛑 [_handleDioError] Forbidden (403)');
        return 'You do not have permission';
      case 404: 
        debugPrint('🛑 [_handleDioError] Not found (404)');
        return 'Resource not found';
      case 422: 
        debugPrint('🛑 [_handleDioError] Unprocessable entity (422)');
        return 'Invalid data, please check your input';
      case 500: 
        debugPrint('🛑 [_handleDioError] Server error (500)');
        return 'Server error, please try again later';
      default:
        break;
    }
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        debugPrint('⏰ [_handleDioError] Timeout');
        return 'Request timeout, please try again';
      case DioExceptionType.connectionError:
        debugPrint('📶 [_handleDioError] Connection error');
        return 'No internet connection';
      default:
        debugPrint('❓ [_handleDioError] Unknown error: ${e.message}');
        return e.message ?? 'Unexpected error occurred';
    }
  }

  String _handleError(Object e) {
    debugPrint('⚠️ [_handleError] General error: $e');
    return e.toString();
  }

  void _safeEmit(StudentState state) {
    if (!isClosed) {
      debugPrint('📤 [_safeEmit] Emitting state: ${state.runtimeType}');
      emit(state);
    } else {
      debugPrint('⚠️ [_safeEmit] Cubit is closed, cannot emit state.');
    }
  }
}