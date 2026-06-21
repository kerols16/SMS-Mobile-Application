// ═══ FILE: lib/features/teacher/data/models/teacher_message_model.dart ═══
import 'package:equatable/equatable.dart';

class TeacherMessageModel extends Equatable {
  final int id;
  final int senderId;
  final int receiverId;
  final int? studentId;
  final String subject;
  final String content;
  final String type;
  final String status;
  final String createdAt;
  final Map<String, dynamic>? sender;
  final Map<String, dynamic>? receiver;
  final Map<String, dynamic>? student;

  const TeacherMessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    this.studentId,
    required this.subject,
    required this.content,
    required this.type,
    required this.status,
    required this.createdAt,
    this.sender,
    this.receiver,
    this.student,
  });

  factory TeacherMessageModel.fromJson(Map<String, dynamic> json) {
    return TeacherMessageModel(
      id: json['id'] as int,
      senderId: json['sender_id'] as int,
      receiverId: json['receiver_id'] as int,
      studentId: json['student_id'] as int?,
      subject: json['subject'] as String,
      content: json['content'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
      createdAt: json['created_at'] as String,
      sender: json['sender'] as Map<String, dynamic>?,
      receiver: json['receiver'] as Map<String, dynamic>?,
      student: json['student'] as Map<String, dynamic>?,
    );
  }

  String get displayName {
    if (sender != null && sender!['role'] == 'teacher') {
      // Message sent by teacher (current user) - show receiver name
      return receiver?['name'] as String? ?? 'Unknown';
    } else {
      // Message received by teacher - show sender name
      return sender?['name'] as String? ?? 'Unknown';
    }
  }

  String get studentName {
    if (student != null && student!['user'] != null) {
      return student!['user']['name'] as String? ?? '';
    }
    return '';
  }

  @override
  List<Object?> get props => [id, senderId, receiverId, subject, status, createdAt];
}