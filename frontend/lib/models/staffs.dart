
class Staffs {
  final String id;
  final String title;
  final String location;
  final int type;
  final String bio;
  final String photo;


  Staffs({
    required this.id,
    required this.title,
    required this.location,
    required this.type,
    required this.bio,
    required this.photo
  });

  factory Staffs.fromJson(Map<String, dynamic> json) {
    return Staffs(
      id: json['_id'] ?? '',       // MongoDB object ID
      title: json['title'] ?? '',
      location: json['location'] ?? '',
      type: json['type'],
      bio: json['bio'] ?? '',
      photo: json['photo'] ?? '',
    );
  }
}