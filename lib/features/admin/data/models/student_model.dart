class AdminStudentModel {
  final int id;
  final int userId;
  final String studentId;
  final String gender;
  final String address;
  final String phone;
  final String enrollmentDate;
  final String dateOfBirth;
  // nested user
  final String name;
  final String email;

  AdminStudentModel({
    required this.id,
    required this.userId,
    required this.studentId,
    required this.gender,
    required this.address,
    required this.phone,
    required this.enrollmentDate,
    required this.dateOfBirth,
    required this.name,
    required this.email,
  });

 factory AdminStudentModel.fromJson(Map<String, dynamic> json) {
  return AdminStudentModel(
   
    id: json['id'] ?? 0,
    userId: json['user_id'],

    studentId: json['student_id'] ?? '',
    gender: json['gender'] ?? '',
    address: json['address'] ?? '',
    phone: json['phone'] ?? '',
    enrollmentDate: json['enrollment_date'] ?? '',
    dateOfBirth: json['date_of_birth'] ?? '',

    name: json['user']?['name'] ?? 'Unknown',
    email: json['user']?['email'] ?? 'No Email',
  );
}}