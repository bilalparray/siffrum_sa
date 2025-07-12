class RandomUser {
  final String firstName;
  final String lastName;
  final String email;
  final String thumbnailUrl;

  RandomUser({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.thumbnailUrl,
  });

  factory RandomUser.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as Map<String, dynamic>;
    final picture = json['picture'] as Map<String, dynamic>;
    return RandomUser(
      firstName: name['first'] as String,
      lastName: name['last'] as String,
      email: json['email'] as String,
      thumbnailUrl: picture['thumbnail'] as String,
    );
  }
}
