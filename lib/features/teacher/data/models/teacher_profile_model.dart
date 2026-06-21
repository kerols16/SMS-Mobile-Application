class TeacherProfileModel {
  final int id;
  final String name;
  final String role;

  TeacherProfileModel({
    required this.id,
    required this.name,
    required this.role,
  });

  factory TeacherProfileModel.fromJson(Map<String, dynamic> json) {
    return TeacherProfileModel(
      id: json['id'],
      name: json['name'] ?? '',
      role: json['role'] ?? '',
    );
  }
}