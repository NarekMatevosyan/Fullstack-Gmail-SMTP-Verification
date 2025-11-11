// To parse this JSON data, do
//
//     final exerciseNotesModel = exerciseNotesModelFromJson(jsonString);

import 'dart:convert';

List<ExerciseNotesModel> exerciseNotesModelFromJson(String str) =>
    List<ExerciseNotesModel>.from(json.decode(str).map((x) => ExerciseNotesModel.fromJson(x)));

String exerciseNotesModelToJson(List<ExerciseNotesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ExerciseNotesModel {
  int? id;
  String? exerciseId;
  DateTime? date;
  String? note;

  ExerciseNotesModel({
    this.id,
    this.exerciseId,
    this.date,
    this.note,
  });

  factory ExerciseNotesModel.fromJson(Map<String, dynamic> json) => ExerciseNotesModel(
        id: json["id"],
        exerciseId: json["exerciseId"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        note: json["note"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "exerciseId": exerciseId,
        "date": date?.toIso8601String(),
        "note": note,
      };
}
