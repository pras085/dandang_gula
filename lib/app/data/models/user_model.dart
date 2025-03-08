class User {
  final String id;
  final String name;
  final String email;
  final String role; // admin, kasir, gudang, pusat, branchmanager
  final String branchId;
  final String branchName;
  final String? photoUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.branchId,
    required this.branchName,
    this.photoUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      branchId: json['branch_id'],
      branchName: json['branch_name'],
      photoUrl: json['photo_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'branch_id': branchId,
      'branch_name': branchName,
      'photo_url': photoUrl,
    };
  }
}
