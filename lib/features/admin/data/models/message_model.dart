import 'package:equatable/equatable.dart';

class Attachment {
  final String name;
  final String url;

  Attachment({required this.name, required this.url});

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'name': name, 'url': url};
}

class MessageModel extends Equatable {
  final int id;
  final int senderId;
  final int receiverId;
  final int? studentId;        // optional, if message is about a specific student
  final String subject;
  final String content;
  final String type;           // e.g., academic, administrative, general
  final List<Attachment>? attachments;
  final bool isRead;
  final String createdAt;
  final String? updatedAt;

  const MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    this.studentId,
    required this.subject,
    required this.content,
    required this.type,
    this.attachments,
    required this.isRead,
    required this.createdAt,
    this.updatedAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final attachList = json['attachments'] as List?;
    return MessageModel(
      id: json['id'] as int,
      senderId: json['sender_id'] as int,
      receiverId: json['receiver_id'] as int,
      studentId: json['student_id'] as int?,
      subject: json['subject'] as String,
      content: json['content'] as String,
      type: json['type'] as String,
      attachments: attachList?.map((e) => Attachment.fromJson(e)).toList(),
      isRead: json['is_read'] as bool? ?? false,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'student_id': studentId,
      'subject': subject,
      'content': content,
      'type': type,
      'attachments': attachments?.map((a) => a.toJson()).toList(),
      'is_read': isRead,
    };
  }

  @override
  List<Object?> get props => [
    id, senderId, receiverId, studentId, subject, content, type, attachments, isRead, createdAt
  ];
}