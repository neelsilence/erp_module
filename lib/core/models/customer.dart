class Customer {
  const Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
  });

  final String id;
  final String name;
  final String phone;
  final String email;
  final String address;

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      address: json['address'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
    };
  }
}
