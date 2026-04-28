class UserModel {
  final int    id;
  final String name;
  final String role;
  final String token;

  UserModel({
    required this.id,
    required this.name,
    required this.role,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id:    json['data']['user']['id'],
      name:  json['data']['user']['name'],
      role:  json['data']['user']['role'],
      token: json['data']['token'],
    );
  }
}