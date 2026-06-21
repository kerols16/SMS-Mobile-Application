import 'dart:convert';

import 'package:equatable/equatable.dart';

class ResourceModel extends Equatable {
  final int id;
  final String title;
  final String description;
  final String type;           // e.g., lesson_plan, document, video, etc.
  final int? subjectId;
  final int? classroomId;
  final String visibility;     // e.g., public, teachers_only, students_only
  final List<String> tags;
  final String fileUrl;
  final int uploaderId;
  final int downloadsCount;
  final String createdAt;
  final String? updatedAt;

  const ResourceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.subjectId,
    this.classroomId,
    required this.visibility,
    required this.tags,
    required this.fileUrl,
    required this.uploaderId,
    required this.downloadsCount,
    required this.createdAt,
    this.updatedAt,
  });

  factory ResourceModel.fromJson(Map<String, dynamic> json) {
    // tags can be a JSON string or a list; we handle both
    List<String> parseTags(dynamic tagsData) {
      if (tagsData == null) return [];
      if (tagsData is List) {
        return tagsData.map((e) => e.toString()).toList();
      } else if (tagsData is String) {
        try {
          final decoded = jsonDecode(tagsData);
          if (decoded is List) {
            return decoded.map((e) => e.toString()).toList();
          }
        } catch (_) {}
        return [];
      }
      return [];
    }

    return ResourceModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      subjectId: json['subject_id'] as int?,
      classroomId: json['classroom_id'] as int?,
      visibility: json['visibility'] as String,
      tags: parseTags(json['tags']),
      fileUrl: json['file_url'] as String,
      uploaderId: json['uploader_id'] as int,
      downloadsCount: json['downloads_count'] as int? ?? 0,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'subject_id': subjectId,
      'classroom_id': classroomId,
      'visibility': visibility,
      'tags': tags,
      'file_url': fileUrl,
      'uploader_id': uploaderId,
      'downloads_count': downloadsCount,
    };
  }

  @override
  List<Object?> get props => [
    id, title, description, type, subjectId, classroomId,
    visibility, tags, fileUrl, uploaderId, downloadsCount, createdAt
  ];
}