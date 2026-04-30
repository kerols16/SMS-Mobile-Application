class AdminTeacherModel {
  final int id;
  final String teacherId;
  final String gender;
  final String address;
  final String phone;
  final String hireDate;
  final String qualification;
  final String subjectSpecialization;
  final String name;
  final String email;

  AdminTeacherModel({
    required this.id,
    required this.teacherId,
    required this.gender,
    required this.address,
    required this.phone,
    required this.hireDate,
    required this.qualification,
    required this.subjectSpecialization,
    required this.name,
    required this.email,
  });

  factory AdminTeacherModel.fromJson(Map<String, dynamic> json) {
    return AdminTeacherModel(
      id:                    json['id'] ?? 0,
      teacherId:             json['teacher_id'] ?? '',
      gender:                json['gender'] ?? '',
      address:               json['address'] ?? '',
      phone:                 json['phone'] ?? '',
      hireDate:              json['hire_date'] ?? '',
      qualification:         json['qualification'] ?? '',
      subjectSpecialization: json['subject_specialization'] ?? '',

      name:  json['user']?['name'] ?? 'Unknown',
      email: json['user']?['email'] ?? 'No Email',
    );
  }
}