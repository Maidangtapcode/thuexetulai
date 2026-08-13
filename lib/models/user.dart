class User {
  final String id;
  final String email;
  final String name;
  final String emaill;
  final String phone;
  final String role;
  final bool isActive;
  final DateTime created;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.emaill,
    required this.phone,
    required this.role,
    required this.isActive,
    required this.created,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? emaill,
    String? phone,
    String? role,
    bool? isActive,
    DateTime? created,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      emaill: emaill ?? this.emaill,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      created: created ?? this.created,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      emaill: json['emaill'] ?? '',
      //avatar: json['avatar'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? 'user',
      isActive: json['isActive'] ?? false,
      created: DateTime.parse(json['created']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'emaill': emaill,
      //'avatar': avatar,
      'phone': phone,
      'role': role,
      'isActive': isActive,
    };
  }
}
