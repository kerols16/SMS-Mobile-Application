class AdminParentModel {
  final int id;
  final String parentId;
  final String phone;
  final String address;
  final String occupation;
  final String name;
  final String email;

  AdminParentModel({
    required this.id,
    required this.parentId,
    required this.phone,
    required this.address,
    required this.occupation,
    required this.name,
    required this.email,
  });

  factory AdminParentModel.fromJson(Map<String, dynamic> json) {
    return AdminParentModel(
      id:         json['id'] ?? 0,
      parentId:   json['parent_id'] ?? '',
      phone:      json['phone'] ?? '',
      address:    json['address'] ?? '',
      occupation: json['occupation'] ?? '',

      name:  json['user']?['name'] ?? 'Unknown',
      email: json['user']?['email'] ?? 'No Email',
    );
  }
}