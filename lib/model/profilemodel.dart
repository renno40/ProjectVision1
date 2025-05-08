class Profile {
  final String id;
  final String email;
  final String username;
  final String date_birth;
  final String vision_problem;
  final String password;

  Profile({
    required this.id,
    required this.email,
    required this.username,
    required this.date_birth,
    required this.vision_problem,
    required this.password,});

  factory Profile.fromMap(Map<String, dynamic> m) => Profile(
    id: m['id'] as String,
    email: m['email'] as String? ?? '',
    username: m['username'] as String? ?? '',
    date_birth: m['date_birth'] as String? ?? '',
    vision_problem: m['vision_problem'] as String? ?? '',
    password: m['password'] as String? ?? '',

  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'email': email,
    'username': username,
    'date_birth': date_birth,
    'vision_problem': vision_problem,
    'password': password,
  };
}
