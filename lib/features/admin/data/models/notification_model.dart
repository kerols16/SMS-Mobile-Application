class AdminNotificationModel {
  final int id;
  final String type;
  final String title;
  final String message;
  final String? link;
  final bool isRead;
  final String createdAt;

  AdminNotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    this.link,
    required this.isRead,
    required this.createdAt,
  });

  factory AdminNotificationModel.fromJson(Map<String, dynamic> json) {
    return AdminNotificationModel(
      id:        json['id'] ?? 0,
      type:      json['type'] ?? '',
      title:     json['title'] ?? '',
      message:   json['message'] ?? '',
      link:      json['link'],
      isRead:    json['is_read'] ?? false,
      createdAt: json['created_at'] ?? '',
    );
  }
}