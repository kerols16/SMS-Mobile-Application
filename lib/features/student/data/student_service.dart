import 'package:dio/dio.dart';
import 'package:school_test/features/student/data/models/student_teacher_model.dart';
import '../../../core/constants/api_constants.dart';
import 'models/student_profile_model.dart';
import 'models/student_dashboard_model.dart';
import 'models/student_schedule_model.dart';
import 'models/student_grade_model.dart';
import 'models/student_exam_model.dart';
import 'models/student_subject_model.dart';
import 'models/student_classroom_model.dart';
import 'models/student_assignment_model.dart';
import 'models/student_submission_model.dart';
import 'models/student_attendance_model.dart';
import 'models/student_resource_model.dart';

class StudentService {
  final Dio _dio;
  StudentService(this._dio);

  // ─── Auth ──────────────────────────────────────────────
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _dio.post(
      ApiConstants.authLogin,
      data: {'email': email, 'password': password},
    );
    return response.data['data'];
  }

  Future<Map<String, dynamic>> getMe() async {
    final response = await _dio.get(ApiConstants.authMe);
    return response.data['data'];
  }

  // ─── Student Portal ────────────────────────────────────

  // GET /api/student/profile
  Future<StudentProfileModel> getProfile() async {
    final response = await _dio.get(ApiConstants.studentProfile);
    return StudentProfileModel.fromJson(response.data['data']);
  }

  // GET /api/student/dashboard
  Future<StudentDashboardModel> getDashboard() async {
    final response = await _dio.get(ApiConstants.studentDashboard);
    return StudentDashboardModel.fromJson(response.data['data']);
  }

  // GET /api/student/schedule → flatten days into one list
  Future<List<StudentScheduleModel>> getSchedule() async {
    final response = await _dio.get(ApiConstants.studentSchedule);
    final Map<String, dynamic> dataMap = response.data['data'] ?? {};
    final List<StudentScheduleModel> scheduleList = [];
    dataMap.forEach((day, items) {
      if (items is List) {
        scheduleList.addAll(items.map((e) => StudentScheduleModel.fromJson(e)));
      }
    });
    return scheduleList;
  }

  // GET /api/student/grades (paginated)
  Future<List<StudentGradeModel>> getGrades() async {
    final response = await _dio.get(ApiConstants.studentGrades);
    final List data = response.data['data']['data'] ?? [];
    return data.map((e) => StudentGradeModel.fromJson(e)).toList();
  }

  // GET /api/student/exams (paginated)
  Future<List<StudentExamModel>> getExams() async {
    final response = await _dio.get(ApiConstants.studentExams);
    final List data = response.data['data']['data'] ?? [];
    return data.map((e) => StudentExamModel.fromJson(e)).toList();
  }

  // GET /api/student/subjects → direct array
  Future<List<StudentSubjectModel>> getSubjects() async {
    final response = await _dio.get(ApiConstants.studentSubjects);
    final List data = response.data['data'] ?? [];
    return data.map((e) => StudentSubjectModel.fromJson(e)).toList();
  }

  // GET /api/student/teachers → direct array
  Future<List<StudentTeacherModel>> getTeachers() async {
    final response = await _dio.get(ApiConstants.studentTeachers);
    final List data = response.data['data'] ?? [];
    return data.map((e) => StudentTeacherModel.fromJson(e)).toList();
  }

  // GET /api/student/assignments (paginated)
  Future<List<StudentAssignmentModel>> getAssignments() async {
    final response = await _dio.get(ApiConstants.studentAssignments);
    final List data = response.data['data']['data'] ?? [];
    return data.map((e) => StudentAssignmentModel.fromJson(e)).toList();
  }

  // GET /api/student/assignments/{id}
  Future<StudentAssignmentModel> getAssignmentById(int id) async {
    final response = await _dio.get(ApiConstants.studentAssignmentById(id));
    return StudentAssignmentModel.fromJson(response.data['data']);
  }

  // POST /api/student/assignments/{id}/submit
  Future<void> submitAssignment(int assignmentId, Map<String, dynamic> data) async {
    await _dio.post(
      ApiConstants.studentSubmitAssignment(assignmentId),
      data: data,
    );
  }

  // GET /api/student/submissions (paginated)
  Future<List<StudentSubmissionModel>> getSubmissions() async {
    final response = await _dio.get(ApiConstants.studentSubmissions);
    final List data = response.data['data']['data'] ?? [];
    return data.map((e) => StudentSubmissionModel.fromJson(e)).toList();
  }

  // GET /api/student/attendance (paginated)
  Future<List<StudentAttendanceModel>> getAttendance() async {
    final response = await _dio.get(ApiConstants.studentAttendance);
    final List data = response.data['data']['data'] ?? [];
    return data.map((e) => StudentAttendanceModel.fromJson(e)).toList();
  }

  // GET /api/student/attendance/summary
  Future<StudentAttendanceSummaryModel> getAttendanceSummary() async {
    final response = await _dio.get(ApiConstants.studentAttendanceSummary);
    return StudentAttendanceSummaryModel.fromJson(response.data['data']);
  }

  // GET /api/student/resources (paginated) with query params
  Future<List<StudentResourceModel>> getResources({
    int? subjectId,
    String? type,
    String? search,
  }) async {
    final query = <String, dynamic>{};
    if (subjectId != null) query['subject_id'] = subjectId;
    if (type != null) query['type'] = type;
    if (search != null) query['search'] = search;

    final response = await _dio.get(
      ApiConstants.studentResources,
      queryParameters: query,
    );
    final List data = response.data['data']['data'] ?? [];
    return data.map((e) => StudentResourceModel.fromJson(e)).toList();
  }
}