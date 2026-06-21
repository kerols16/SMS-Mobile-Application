import 'package:equatable/equatable.dart';

class TeacherResourceModel extends Equatable {
  final int id;
  final String title;
  final String? description;
  final String? type;
  final String? filePath;
  final String? visibility;
  final List<String> tags;
  final bool isActive;
  final String? createdAt;

  const TeacherResourceModel({
    required this.id,
    required this.title,
    this.description,
    this.type,
    this.filePath,
    this.visibility,
    this.tags = const [],
    required this.isActive,
    this.createdAt,
  });

  factory TeacherResourceModel.fromJson(Map<String, dynamic> json) {
    return TeacherResourceModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      type: json['type'] as String?,
      filePath: json['file_path'] as String?,
      visibility: json['visibility'] as String?,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'type': type,
    'file_path': filePath,
    'visibility': visibility,
    'tags': tags,
    'is_active': isActive,
    'created_at': createdAt,
  };

  @override
  List<Object?> get props => [
    id, title, description, type, filePath,
    visibility, tags, isActive, createdAt,
  ];
}