class AdminUserModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? emailVerifiedAt;
  final String createdAt;

  AdminUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.emailVerifiedAt,
    required this.createdAt,
  });

  factory AdminUserModel.fromJson(Map<String, dynamic> json) {
    return AdminUserModel(
      id:              json['id'] ?? 0,
      name:            json['name'] ?? 'Unknown',
      email:           json['email'] ?? 'No Email',
      role:            json['role'] ?? 'unknown',
      emailVerifiedAt: json['email_verified_at'],
      createdAt:       json['created_at'] ?? '',
    );
  }
}