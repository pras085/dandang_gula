class Branch {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String email;
  final String managerId;
  final String managerName;
  final bool isActive;

  Branch({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.managerId,
    required this.managerName,
    this.isActive = true,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      managerId: json['manager_id'] as String,
      managerName: json['manager_name'] as String,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
      'manager_id': managerId,
      'manager_name': managerName,
      'is_active': isActive,
    };
  }
}
