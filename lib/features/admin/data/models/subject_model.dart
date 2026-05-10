class SubjectModel {
  final int id;
  final String name;
  final String code;
  final String? description;
  final int credits;
  final String type;
  final bool isActive;
  final List<dynamic> classrooms;
  final List<dynamic> teachers;

  SubjectModel({
    required this.id,
    required this.name,
    required this.code,
    this.description,
    required this.credits,
    required this.type,
    required this.isActive,
    required this.classrooms,
    required this.teachers,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) => SubjectModel(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    code: json['code'] ?? '',
    description: json['description'],
    credits: json['credits'] ?? 0,
    type: json['type'] ?? '',
    isActive: json['is_active'] ?? false,
    classrooms: json['classrooms'] ?? [],
    teachers: json['teachers'] ?? [],
  );
}