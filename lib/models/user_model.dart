class UserModel {
  int? id, rolesId;
  String? nik, name, email, noWa, createdAt, updatedAt;

  UserModel({
    required this.id,
    required this.nik,
    required this.name,
    required this.email,
    required this.noWa,
    required this.rolesId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> object) {
    return UserModel(
      id: object['id'] ?? 0,
      nik: object['nik'] ?? "",
      name: object['name'] ?? "",
      email: object['email'] ?? "",
      noWa: object['no_wa'] ?? "",
      rolesId: object['roles_id'] ?? 0,
      createdAt: object['created_at'] ?? "",
      updatedAt: object['updated_at'] ?? "",
    );
  }
}