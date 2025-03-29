class User {
  final String id;
  final String email;
  final String username;
  // String? avatar;

  User({
    required this.id,
    required this.email,
    required this.username,
    // this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      // avatar: json["avatar"] ?? "defaultavatar.jpg",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      // 'avatar': avatar,
    };
  }
}
