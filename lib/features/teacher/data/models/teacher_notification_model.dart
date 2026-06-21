import 'package:equatable/equatable.dart';

class TeacherNotificationModel extends Equatable {
  final int id;
  final String type;
  final String title;
  final String message;
  final Map<String, dynamic>? data;
  final String? link;
  final String? readAt;
  final String? createdAt;

  const TeacherNotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    this.data,
    this.link,
    this.readAt,
    this.createdAt,
  });

  bool get isRead => readAt != null;
  bool get isUnread => readAt == null;

  factory TeacherNotificationModel.fromJson(Map<String, dynamic> json) {
    return TeacherNotificationModel(
      id: json['id'] as int,
      type: json['type'] as String? ?? '',
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      data: json['data'] as Map<String, dynamic>?,
      link: json['link'] as String?,
      readAt: json['read_at'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'title': title,
    'message': message,
    'data': data,
    'link': link,
    'read_at': readAt,
    'created_at': createdAt,
  };

  @override
  List<Object?> get props => [
    id, type, title, message, data,
    link, readAt, createdAt,
  ];
}