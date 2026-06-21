import 'package:equatable/equatable.dart';
import 'student_classroom_model.dart';

class StudentProfileModel extends Equatable {
  final int id;
  final int userId;
  final String studentId;
  final String dateOfBirth;
  final String gender;
  final String address;
  final String phone;
  final String enrollmentDate;
  final String name;
  final String email;
  final String? profilePicture;
  final List<StudentClassroomModel> classrooms;

  const StudentProfileModel({
    required this.id,
    required this.userId,
    required this.studentId,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
    required this.phone,
    required this.enrollmentDate,
    required this.name,
    required this.email,
    this.profilePicture,
    this.classrooms = const [],
  });

  factory StudentProfileModel.fromJson(Map<String, dynamic> json) {
    final classroomsData = json['classrooms'] as List? ?? [];
    return StudentProfileModel(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      studentId: json['student_id'] as String? ?? '',
      dateOfBirth: json['date_of_birth'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      address: json['address'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      enrollmentDate: json['enrollment_date'] as String? ?? '',
      name: json['user']?['name'] as String? ?? 'Unknown',
      email: json['user']?['email'] as String? ?? '',
      profilePicture: json['profile_picture'] as String?,
      classrooms: classroomsData.map((e) => StudentClassroomModel.fromJson(e)).toList(),
    );
  }

  @override
  List<Object?> get props => [id, name, email, classrooms];
}