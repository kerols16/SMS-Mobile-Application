import 'package:dio/dio.dart';
import 'package:school_test/features/teacher/data/models/teacher_assignment_model.dart';
import 'package:school_test/features/teacher/data/models/teacher_attendance_model.dart';
import 'package:school_test/features/teacher/data/models/teacher_classroom_model.dart';
import 'package:school_test/features/teacher/data/models/teacher_exam_model.dart';
import 'package:school_test/features/teacher/data/models/teacher_grade_model.dart';
import 'package:school_test/features/teacher/data/models/teacher_message_model.dart';
import 'package:school_test/features/teacher/data/models/teacher_notification_model.dart';
import 'package:school_test/features/teacher/data/models/teacher_profile_model.dart';
import 'package:school_test/features/teacher/data/models/teacher_resource_model.dart';
import 'package:school_test/features/teacher/data/models/teacher_student_model.dart';
import 'package:school_test/features/teacher/data/models/teacher_submission_model.dart';
import '../../../../core/constants/api_constants.dart';

class TeacherService {
  final Dio _dio;
  TeacherService(this._dio);

  // ═══════════════════════════════════════════════════════════
  // PROFILE
  // ═══════════════════════════════════════════════════════════
  Future<TeacherProfileModel> getMyProfile() async {
    final response = await _dio.get(ApiConstants.teacherProfile);
    return TeacherProfileModel.fromJson(response.data['data']);
  }

  Future<TeacherProfileModel> getTeacherUser() async {
    final response = await _dio.get(ApiConstants.authMe);
    return TeacherProfileModel.fromJson(response.data['data']);
  }

  Future<int> getMyTeacherId() async {
    final profile = await getMyProfile();
    return profile.id;
  }

  // ═══════════════════════════════════════════════════════════
  // CLASSROOMS
  // ═══════════════════════════════════════════════════════════
  Future<List<TeacherClassroomModel>> getMyClassrooms() async {
    final response = await _dio.get(ApiConstants.apiTeacherClassrooms);
    final List data = response.data['data'] as List? ?? [];
    return data.map((e) => TeacherClassroomModel.fromJson(e)).toList();
  }

  Future<TeacherClassroomModel> getClassroomById(int id) async {
    final response = await _dio.get(ApiConstants.teacherClassroomById(id));
    return TeacherClassroomModel.fromJson(response.data['data']);
  }

  // ═══════════════════════════════════════════════════════════
  // STUDENTS
  // ═══════════════════════════════════════════════════════════
  Future<List<TeacherStudentModel>> getMyStudents() async {
    final response = await _dio.get(ApiConstants.apiTeacherStudents);
    final List data = response.data['data']['data'] as List? ?? [];
    return data.map((e) => TeacherStudentModel.fromJson(e)).toList();
  }

  Future<TeacherStudentModel> getStudentById(int id) async {
    final response = await _dio.get(ApiConstants.teacherStudentById(id));
    return TeacherStudentModel.fromJson(response.data['data']);
  }

  // ═══════════════════════════════════════════════════════════
  // ASSIGNMENTS
  // ═══════════════════════════════════════════════════════════
  Future<List<TeacherAssignmentModel>> getMyAssignments() async {
    final response = await _dio.get(ApiConstants.teacherAssignments);
    final List data = response.data['data']['data'] as List? ?? [];
    return data.map((e) => TeacherAssignmentModel.fromJson(e)).toList();
  }

  Future<TeacherAssignmentModel> getAssignmentById(int id) async {
    final response = await _dio.get(ApiConstants.teacherAssignmentById(id));
    return TeacherAssignmentModel.fromJson(response.data['data']);
  }

  Future<TeacherAssignmentModel> createAssignment(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiConstants.teacherAssignments, data: data);
    return TeacherAssignmentModel.fromJson(response.data['data']);
  }

  Future<TeacherAssignmentModel> updateAssignment(int id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiConstants.teacherAssignmentById(id), data: data);
    return TeacherAssignmentModel.fromJson(response.data['data']);
  }

  Future<void> deleteAssignment(int id) async {
    await _dio.delete(ApiConstants.teacherAssignmentById(id));
  }

  Future<List<TeacherSubmissionModel>> getAssignmentSubmissions(int assignmentId) async {
    final response = await _dio.get(ApiConstants.teacherAssignmentSubmissions(assignmentId));
    final List data = response.data['data']['data'] as List? ?? [];
    return data.map((e) => TeacherSubmissionModel.fromJson(e)).toList();
  }

  // ═══════════════════════════════════════════════════════════
  // SUBMISSIONS & GRADING
  // ═══════════════════════════════════════════════════════════
  Future<List<TeacherSubmissionModel>> getMySubmissions() async {
    final response = await _dio.get(ApiConstants.teacherSubmissions);
    final List data = response.data['data']['data'] as List? ?? [];
    return data.map((e) => TeacherSubmissionModel.fromJson(e)).toList();
  }

  Future<TeacherSubmissionModel> getSubmissionById(int id) async {
    final response = await _dio.get(ApiConstants.teacherSubmissionById(id));
    return TeacherSubmissionModel.fromJson(response.data['data']);
  }

  Future<TeacherSubmissionModel> gradeSubmission(
    int submissionId, {
    required int score,
    required String feedback,
  }) async {
    final response = await _dio.post(
      ApiConstants.teacherGradeSubmission(submissionId),
      data: {
        'score': score,
        'feedback': feedback,
      },
    );
    return TeacherSubmissionModel.fromJson(response.data['data']);
  }

  Future<TeacherSubmissionModel> updateSubmissionGrade(
    int submissionId, {
    required int score,
    required String feedback,
  }) async {
    final response = await _dio.put(
      ApiConstants.teacherSubmissionById(submissionId),
      data: {
        'score': score,
        'feedback': feedback,
      },
    );
    return TeacherSubmissionModel.fromJson(response.data['data']);
  }

  Future<void> deleteSubmission(int id) async {
    await _dio.delete(ApiConstants.teacherSubmissionById(id));
  }

  // ═══════════════════════════════════════════════════════════
  // GRADES
  // ═══════════════════════════════════════════════════════════
  Future<List<TeacherGradeModel>> getMyGrades() async {
    final response = await _dio.get(ApiConstants.teacherGrades);
    final List data = response.data['data']['data'] as List? ?? [];
    return data.map((e) => TeacherGradeModel.fromJson(e)).toList();
  }

  Future<TeacherGradeModel> getGradeById(int id) async {
    final response = await _dio.get(ApiConstants.teacherGradeById(id));
    return TeacherGradeModel.fromJson(response.data['data']);
  }

  Future<TeacherGradeModel> createGrade(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiConstants.teacherGrades, data: data);
    return TeacherGradeModel.fromJson(response.data['data']);
  }

  Future<TeacherGradeModel> updateGrade(int id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiConstants.teacherGradeById(id), data: data);
    return TeacherGradeModel.fromJson(response.data['data']);
  }

  Future<void> deleteGrade(int id) async {
    await _dio.delete(ApiConstants.teacherGradeById(id));
  }

  Future<List<TeacherGradeModel>> getStudentGrades(int studentId) async {
    final response = await _dio.get(ApiConstants.teacherStudentGrades(studentId));
    final List data = response.data['data']['data'] as List? ?? [];
    return data.map((e) => TeacherGradeModel.fromJson(e)).toList();
  }

  // ═══════════════════════════════════════════════════════════
  // ATTENDANCE
  // ═══════════════════════════════════════════════════════════
  Future<List<TeacherAttendanceModel>> getMyAttendance() async {
    final response = await _dio.get(ApiConstants.teacherAttendance);
    final List data = response.data['data']['data'] as List? ?? [];
    return data.map((e) => TeacherAttendanceModel.fromJson(e)).toList();
  }

  Future<TeacherAttendanceModel> getAttendanceById(int id) async {
    final response = await _dio.get(ApiConstants.teacherAttendanceById(id));
    return TeacherAttendanceModel.fromJson(response.data['data']);
  }

  Future<TeacherAttendanceModel> recordAttendance(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiConstants.teacherAttendance, data: data);
    return TeacherAttendanceModel.fromJson(response.data['data']);
  }

  Future<TeacherAttendanceModel> updateAttendance(int id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiConstants.teacherAttendanceById(id), data: data);
    return TeacherAttendanceModel.fromJson(response.data['data']);
  }

  Future<void> deleteAttendance(int id) async {
    await _dio.delete(ApiConstants.teacherAttendanceById(id));
  }

  Future<Map<String, dynamic>> getClassroomAttendanceSummary(int classroomId) async {
    final response = await _dio.get(ApiConstants.teacherClassroomAttendanceSummary(classroomId));
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getStudentAttendanceSummary(int studentId) async {
    final response = await _dio.get(ApiConstants.teacherStudentAttendanceSummary(studentId));
    return response.data['data'] as Map<String, dynamic>;
  }

  // ═══════════════════════════════════════════════════════════
  // EXAMS
  // ═══════════════════════════════════════════════════════════
  Future<List<TeacherExamModel>> getMyExams() async {
    final response = await _dio.get(ApiConstants.teacherExams);
    final List data = response.data['data']['data'] as List? ?? [];
    return data.map((e) => TeacherExamModel.fromJson(e)).toList();
  }

  Future<TeacherExamModel> getExamById(int id) async {
    final response = await _dio.get(ApiConstants.teacherExamById(id));
    return TeacherExamModel.fromJson(response.data['data']);
  }

  Future<TeacherExamModel> createExam(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiConstants.teacherExams, data: data);
    return TeacherExamModel.fromJson(response.data['data']);
  }

  Future<TeacherExamModel> updateExam(int id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiConstants.teacherExamById(id), data: data);
    return TeacherExamModel.fromJson(response.data['data']);
  }

  Future<void> deleteExam(int id) async {
    await _dio.delete(ApiConstants.teacherExamById(id));
  }

  Future<List<TeacherGradeModel>> getExamResults(int examId) async {
    final response = await _dio.get(ApiConstants.teacherExamResults(examId));
    final List data = response.data['data']['data'] as List? ?? [];
    return data.map((e) => TeacherGradeModel.fromJson(e)).toList();
  }

  // ═══════════════════════════════════════════════════════════
  // MESSAGES
  // ═══════════════════════════════════════════════════════════
  Future<List<TeacherMessageModel>> getMessages() async {
    final response = await _dio.get(ApiConstants.teacherMessages);
    final List data = response.data['data']['data'] as List? ?? [];
    return data.map((e) => TeacherMessageModel.fromJson(e)).toList();
  }

  Future<TeacherMessageModel> getMessageById(int id) async {
    final response = await _dio.get(ApiConstants.teacherMessageById(id));
    return TeacherMessageModel.fromJson(response.data['data']);
  }

 Future<void> sendMessage({
  required int receiverId,
  int? studentId,
  required String subject,
  required String content,
  required String type,
  int? replyTo,
}) async {
  final Map<String, dynamic> payload = {
    'receiver_id': receiverId,
    'subject': subject,
    'content': content,
    'type': type,
  };
  if (studentId != null) payload['student_id'] = studentId;
  if (replyTo != null) payload['reply_to'] = replyTo;

  print('📤 Sending payload: $payload');
  final response = await _dio.post(
    ApiConstants.teacherMessages, 
    data: payload,
  );
  print('✅ sendMessage response: ${response.data}');
}

  Future<TeacherMessageModel> updateMessageStatus(int id, String status) async {
    final response = await _dio.put(
      ApiConstants.teacherMessageById(id),
      data: {'status': status},
    );
    return TeacherMessageModel.fromJson(response.data['data']);
  }

  Future<void> deleteMessage(int id) async {
    await _dio.delete(ApiConstants.teacherMessageById(id));
  }

  Future<int> getUnreadMessageCount() async {
    final response = await _dio.get(ApiConstants.teacherMessagesUnreadCount);
    return response.data['data']['count'] ?? 0;
  }
Future<List<Map<String, dynamic>>> getAvailableParents({String? search}) async {
  try {
    final query = search != null ? {'search': search} : null;
    final response = await _dio.get(
      ApiConstants.teacherMessagesAvailableParents,
      queryParameters: query,
    );

    print('📦 Raw response: ${response.data}'); // اختياري

    final Map<String, dynamic> json = response.data;
    final List<dynamic>? list = json['data']?['data'] as List?;

    if (list == null) {
      throw Exception('No parent list found. Response keys: ${json.keys}');
    }

    return list.map((e) => Map<String, dynamic>.from(e)).toList();
  } catch (e) {
    print('❌ Error in getAvailableParents: $e');
    rethrow;
  }
}

  // ═══════════════════════════════════════════════════════════
  // RESOURCES
  // ═══════════════════════════════════════════════════════════
  Future<List<TeacherResourceModel>> getResources({
    String? type,
    int? subjectId,
  }) async {
    final query = <String, dynamic>{};
    if (type != null) query['type'] = type;
    if (subjectId != null) query['subject_id'] = subjectId;
    final response = await _dio.get(ApiConstants.teacherResources, queryParameters: query);
    final List data = response.data['data']['data'] as List? ?? [];
    return data.map((e) => TeacherResourceModel.fromJson(e)).toList();
  }

  Future<List<TeacherResourceModel>> getMyResources() async {
    final response = await _dio.get(ApiConstants.teacherResourcesMy);
    final List data = response.data['data']['data'] as List? ?? [];
    return data.map((e) => TeacherResourceModel.fromJson(e)).toList();
  }

  Future<List<TeacherResourceModel>> getPopularResources() async {
    final response = await _dio.get(ApiConstants.teacherResourcesPopular);
    final List data = response.data['data']['data'] as List? ?? [];
    return data.map((e) => TeacherResourceModel.fromJson(e)).toList();
  }

  Future<TeacherResourceModel> getResourceById(int id) async {
    final response = await _dio.get(ApiConstants.teacherResourceById(id));
    return TeacherResourceModel.fromJson(response.data['data']);
  }

  Future<TeacherResourceModel> createResource(FormData formData) async {
    final response = await _dio.post(ApiConstants.teacherResources, data: formData);
    return TeacherResourceModel.fromJson(response.data['data']);
  }

  Future<TeacherResourceModel> updateResource(int id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiConstants.teacherResourceById(id), data: data);
    return TeacherResourceModel.fromJson(response.data['data']);
  }

  Future<void> deleteResource(int id) async {
    await _dio.delete(ApiConstants.teacherResourceById(id));
  }

  Future<String> downloadResource(int id) async {
    final response = await _dio.get(ApiConstants.teacherResourceDownload(id));
    return response.data['data']['file_url'] ?? '';
  }

  // ═══════════════════════════════════════════════════════════
  // NOTIFICATIONS
  // ═══════════════════════════════════════════════════════════
  Future<List<TeacherNotificationModel>> getMyNotifications() async {
    final response = await _dio.get(ApiConstants.teacherNotifications);
    final List data = response.data['data']['data'] as List? ?? [];
    return data.map((e) => TeacherNotificationModel.fromJson(e)).toList();
  }

  Future<int> getUnreadNotificationCount() async {
    final response = await _dio.get(ApiConstants.teacherNotificationsUnreadCount);
    return response.data['data']['count'] ?? 0;
  }

  Future<TeacherNotificationModel> getNotificationById(int id) async {
    final response = await _dio.get(ApiConstants.teacherNotificationById(id));
    return TeacherNotificationModel.fromJson(response.data['data']);
  }

  Future<void> markNotificationRead(int id) async {
    await _dio.post(ApiConstants.teacherNotificationMarkRead(id));
  }

  Future<void> markAllNotificationsRead() async {
    await _dio.post(ApiConstants.teacherNotificationsMarkAllRead);
  }

  Future<void> deleteNotification(int id) async {
    await _dio.delete(ApiConstants.teacherNotificationById(id));
  }
}