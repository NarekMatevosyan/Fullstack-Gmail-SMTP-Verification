class Challenges {
  final String id;
  final String title;
  final String description;
  final String photo;


  Challenges({
    required this.id,
    required this.title,
    required this.description,
    required this.photo
  });

  factory Challenges.fromJson(Map<String, dynamic> json) {
    return Challenges(
      id: json['id'] ?? '',       // MongoDB object ID
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      photo: json['photo'] ?? '',
    );
  }
}