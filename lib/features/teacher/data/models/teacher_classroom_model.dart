class TeacherClassroomModel {
  final int id;
  final String name;
  final String gradeLevel;
  final int capacity;
  final String? description;
  final List<dynamic> students; 

  TeacherClassroomModel({
    required this.id,
    required this.name,
    required this.gradeLevel,
    required this.capacity,
    this.description,
    this.students = const [],
  });

  factory TeacherClassroomModel.fromJson(Map<String, dynamic> json) {
    return TeacherClassroomModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      gradeLevel: json['grade_level'] as String? ?? '',
      capacity: json['capacity'] as int? ?? 0,
      description: json['description'] as String?,
      students: json['students'] as List? ?? [],
    );
  }

  bool get isActive => students.length > 1 ? true : false;
}