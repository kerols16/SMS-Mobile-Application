import 'dart:convert';
import 'package:equatable/equatable.dart';

class StudentResourceModel extends Equatable {
  final int id;
  final String title;
  final String description;
  final String type;
  final int? subjectId;
  final int? classroomId;
  final String visibility;
  final List<String> tags;
  final String fileUrl;
  final int uploaderId;
  final int downloadsCount;
  final String createdAt;
  final String? subjectName;

  const StudentResourceModel({
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
    this.subjectName,
  });

  factory StudentResourceModel.fromJson(Map<String, dynamic> json) {
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

    return StudentResourceModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      type: json['type'] as String? ?? '',
      subjectId: json['subject_id'] as int?,
      classroomId: json['classroom_id'] as int?,
      visibility: json['visibility'] as String? ?? '',
      tags: parseTags(json['tags']),
      fileUrl: json['file_url'] as String? ?? '',
      uploaderId: json['uploader_id'] as int? ?? 0,
      downloadsCount: json['downloads_count'] as int? ?? 0,
      createdAt: json['created_at'] as String? ?? '',
      subjectName: json['subject']?['name'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, title, type, fileUrl];
}