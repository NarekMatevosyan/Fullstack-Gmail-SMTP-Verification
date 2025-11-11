class EquipmentTitle {
  final String id;
  final String localId;
  final String title;

  EquipmentTitle({required this.id, required this.localId, required this.title});

  factory EquipmentTitle.fromJson(Map<String, dynamic> json) {
    return EquipmentTitle(
      id: json['_id'] ?? '',       // MongoDB object ID
      localId: json['id'] ?? '',   // Local identifier if available
      title: json['title'] ?? 'Unknown Equipment',  // Equipment name/title
    );
  }
}