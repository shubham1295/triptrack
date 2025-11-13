/// User model for authentication
class User {
  final String id;
  final String email;
  final String name;

  User({required this.id, required this.email, required this.name});

  /// Create a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
    );
  }

  /// Convert User to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'name': name};
  }

  /// Create a copy of the user with updated fields
  User copyWith({String? id, String? email, String? name}) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
    );
  }
}
