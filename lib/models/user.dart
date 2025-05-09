class User {
  final String username;
  final String password;
  List<String> favorites;
  List<String> history;

  User({
    required this.username,
    required this.password,
    this.favorites = const [],
    this.history = const [],
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'favorites': favorites,
        'history': history,
      };

  static User fromJson(Map<String, dynamic> json) => User(
        username: json['username'],
        password: json['password'],
        favorites: List<String>.from(json['favorites'] ?? []),
        history: List<String>.from(json['history'] ?? []),
      );
}