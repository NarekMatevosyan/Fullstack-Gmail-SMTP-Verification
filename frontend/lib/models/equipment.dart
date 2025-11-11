class Equipment {
  Equipment({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.description,
    required this.link,
    required this.createdAt,
  });

  String id;
  String title;
  String thumbnail;
  String description;
  String link;
  String createdAt;

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['_id'] ?? '',       // MongoDB object ID
      title: json['title'] ?? '',
      description: json['description'],
      thumbnail: json['thumbnail'] ?? '',
      link: json['link'] ?? [],
      createdAt: json['createdAt'] ?? '',
    );
  }
}
