class ClassroomModel {
  final int id;
  final String name;
  final String gradeLevel;     
  final int capacity;
  final String academicYear;
  final String? description;
  final bool isActive;
  final List<dynamic> students; // يمكنك لاحقاً استخدام StudentModel
  final List<dynamic> teachers; // يمكنك لاحقاً استخدام TeacherModel
  final List<dynamic> subjects; // يمكنك لاحقاً استخدام SubjectModel

  ClassroomModel({
    required this.id,
    required this.name,
    required this.gradeLevel,
    required this.capacity,
    required this.academicYear,
    this.description,
    required this.isActive,
    required this.students,
    required this.teachers,
    required this.subjects,
  });

  factory ClassroomModel.fromJson(Map<String, dynamic> json) => ClassroomModel(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    gradeLevel: json['grade_level'] ?? '',
    capacity: json['capacity'] ?? 0,
    academicYear: json['academic_year'] ?? '',
    description: json['description'],
    isActive: json['is_active'] ?? false,
    students: json['students'] ?? [],
    teachers: json['teachers'] ?? [],
    subjects: json['subjects'] ?? [],
  );
}