// class Athletes {
//   final String id;
//   final String title;
//   final String location;
//   final int type;
//   final String bio;
//   final String photo;
//
//
//   Athletes({
//     required this.id,
//     required this.title,
//     required this.location,
//     required this.type,
//     required this.bio,
//     required this.photo
//   });
//
//   factory Athletes.fromJson(Map<String, dynamic> json) {
//     return Athletes(
//       id: json['_id'] ?? '',       // MongoDB object ID
//       title: json['title'] ?? '',
//       location: json['location'] ?? '',
//       type: json['type'],
//       bio: json['bio'] ?? '',
//       photo: json['photo'] ?? '',
//     );
//   }
// }
