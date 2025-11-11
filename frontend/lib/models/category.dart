class CategoryTitle {
  final String id;
  final String localId;
  final String title;

  CategoryTitle({required this.id, required this.localId, required this.title});

  factory CategoryTitle.fromJson(Map<String, dynamic> json) {
    return CategoryTitle(
      id: json['_id'] ?? '',       // MongoDB object ID
      localId: json['id'] ?? '',   // Local identifier if available
      title: json['title'] ?? 'Unknown Category',  // Category name/title
    );
  }
}