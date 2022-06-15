class User {
  final String username;
  final String avatar;

  User({required this.username, required this.avatar});

  User.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        avatar = json['avatar'];
}
