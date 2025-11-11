class Tutorials {
  final String id;
  final String title;
  final String description;
  final String photo;
  List<dynamic> files = [];


  Tutorials({
    required this.id,
    required this.title,
    required this.description,
    required this.photo,
    required this.files,
  });

  factory Tutorials.fromJson(Map<String, dynamic> json) {
    return Tutorials(
        id: json['id'] ?? '',       // MongoDB object ID
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        photo: json['imgUrl'] ?? '',
        files: json['files'] ?? []
    );
  }
}