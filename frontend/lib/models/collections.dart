
class Collections {
  final String id;
  final String title;
  final String description;
  final String photo;
  final List<dynamic> equipments;


  Collections({
    required this.id,
    required this.title,
    required this.description,
    required this.photo,
    required this.equipments,
  });

  factory Collections.fromJson(Map<String, dynamic> json) {
    return Collections(
      id: json['_id'] ?? '',       // MongoDB object ID
      title: json['title'] ?? '',
      description: json['description'],
      photo: json['thumbnail'] ?? '',
      equipments: json['relatedEquipment'] ?? [],
    );
  }
}