class User {
  final int id;
  String name; // diubah agar bisa diedit
  final String email;
  final String? emailVerifiedAt;
  final String createdAt;
  final String updatedAt;
  final String role;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      role: json['role'] ?? 'user',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'email_verified_at': emailVerifiedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'role': role,
    };
  }

  bool get isUser => role == 'user';
  bool get isAdmin => role == 'admin';
  bool get isSuperAdmin => role == 'super_admin';

  String get formattedCreatedAt {
    final dateTime = DateTime.parse(createdAt);
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  String get formattedUpdatedAt {
    final dateTime = DateTime.parse(updatedAt);
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? emailVerifiedAt,
    String? createdAt,
    String? updatedAt,
    String? role,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      role: role ?? this.role,
    );
  }
}
