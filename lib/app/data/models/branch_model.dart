class Branch {
  final String id;
  final String name;
  final String? address;
  final String? phone;
  final String? email;
  final String? managerId;
  final String? managerName;
  
  // Financial data
  final double income;
  final double cogs;
  final double netProfit;
  final double percentChange;
  
  Branch({
    required this.id,
    required this.name,
    this.address,
    this.phone,
    this.email,
    this.managerId,
    this.managerName,
    this.income = 0.0,
    this.cogs = 0.0,
    this.netProfit = 0.0,
    this.percentChange = 0.0,
  });

  // Create a copy with updates
  Branch copyWith({
    String? id,
    String? name,
    String? address,
    String? phone,
    String? email,
    String? managerId,
    String? managerName,
    double? income,
    double? cogs,
    double? netProfit,
    double? percentChange,
  }) {
    return Branch(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      managerId: managerId ?? this.managerId,
      managerName: managerName ?? this.managerName,
      income: income ?? this.income,
      cogs: cogs ?? this.cogs,
      netProfit: netProfit ?? this.netProfit,
      percentChange: percentChange ?? this.percentChange,
    );
  }

  // For comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Branch &&
        other.id == id &&
        other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}