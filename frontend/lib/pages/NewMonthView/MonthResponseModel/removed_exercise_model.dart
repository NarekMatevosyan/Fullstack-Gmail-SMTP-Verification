import 'dart:convert';

List<RemovedExerciseModel> removedExerciseModelFromJson(String str) =>
    List<RemovedExerciseModel>.from(json.decode(str).map((x) => RemovedExerciseModel.fromJson(x)));

String removedExerciseModelToJson(List<RemovedExerciseModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RemovedExerciseModel {
  int? id;
  String? dataId;
  String? exerciseId;

  RemovedExerciseModel({
    this.id,
    this.dataId,
    this.exerciseId,
  });

  factory RemovedExerciseModel.fromJson(Map<String, dynamic> json) => RemovedExerciseModel(
        id: json["id"],
        dataId: json["dataId"],
        exerciseId: json["exerciseId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "dataId": dataId,
        "exerciseId": exerciseId,
      };
}
