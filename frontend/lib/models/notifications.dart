
class Notifications {
  final String id;
  final String title;
  final String description;


  Notifications({
    required this.id,
    required this.title,
    required this.description,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      id: json['_id'] ?? '',       // MongoDB object ID
      title: json['title'] ?? '',
      description: json['description']
    );
  }
}