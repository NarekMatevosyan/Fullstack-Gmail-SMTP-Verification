
class Bonuses {
  final String id;
  final String title;
  final String description;
  final String photo;
  final List<dynamic> equipments;
  final String createdAt;


  Bonuses({
    required this.id,
    required this.title,
    required this.description,
    required this.photo,
    required this.equipments,
    required this.createdAt,
  });

  factory Bonuses.fromJson(Map<String, dynamic> json) {
    return Bonuses(
      id: json['_id'] ?? '',       // MongoDB object ID
      title: json['title'] ?? '',
      description: json['description'],
      photo: json['thumbnail'] ?? '',
      equipments: json['relatedEquipment'] ?? [],
      createdAt: json['createdAt'] ?? '',
    );
  }
}