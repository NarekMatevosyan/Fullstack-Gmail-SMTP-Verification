class ExerciseLibrary {
  final String id;
  final String title;
  final String vimeoId;
  final String thumbnail;
  final String description;
  final List<String> categories;
  final String guide;
  final List<String> relatedExercises;
  final String createdAt;
  final String updatedAt;
  final List<String> usedEquipments;

  ExerciseLibrary({
    required this.id,
    required this.title,
    required this.vimeoId,
    required this.thumbnail,
    required this.description,
    required this.categories,
    required this.guide,
    required this.relatedExercises,
    required this.createdAt,
    required this.updatedAt,
    required this.usedEquipments,
  });

  // Factory constructor to create an instance of ExerciseLibrary from JSON
  factory ExerciseLibrary.fromJson(Map<String, dynamic> json) {
    return ExerciseLibrary(
      id: json['_id'] ?? '',
      title: json['title'] ?? 'Unknown Title',
      vimeoId: json['vimeoId'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      description: json['description'] ?? '',
      categories: List<String>.from(json['categories'] ?? []),
      guide: json['guide'] ?? '',
      relatedExercises: List<String>.from(json['relatedExercises'] ?? []),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      usedEquipments: List<String>.from(json['usedEquipments'] ?? []),
    );
  }
}
