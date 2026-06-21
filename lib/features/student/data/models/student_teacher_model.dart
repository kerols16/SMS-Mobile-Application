import 'package:equatable/equatable.dart';

class StudentTeacherModel extends Equatable {
  final int id;
  final String name;
  final String? email;
  final String? subjectName;

  const StudentTeacherModel({
    required this.id,
    required this.name,
    this.email,
    this.subjectName,
  });

  factory StudentTeacherModel.fromJson(Map<String, dynamic> json) {
    return StudentTeacherModel(
      id: json['id'] as int? ?? 0,
      name: json['user']?['name'] as String? ?? 'Unknown',
      email: json['user']?['email'] as String?,
      subjectName: json['subject']?['name'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, name];
}