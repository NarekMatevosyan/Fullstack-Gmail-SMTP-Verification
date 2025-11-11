import 'dart:convert';

List<CircuitModel> circuitModelFromJson(String str) => List<CircuitModel>.from(json.decode(str).map((x) => CircuitModel.fromJson(x)));

String circuitModelToJson(List<CircuitModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CircuitModel {
  int? id;
  String? dataId;
  String? exerciseCountList;
  int? lastExerciseCount;
  int? lastRound;

  CircuitModel({
    this.id,
    this.dataId,
    this.lastExerciseCount,
    this.lastRound,
    this.exerciseCountList,
  });

  factory CircuitModel.fromJson(Map<String, dynamic> json) => CircuitModel(
        id: json["id"],
        dataId: json["dataId"],
        exerciseCountList: json["exerciseCountList"] ?? "",
        lastExerciseCount: json["lastExerciseCount"] ?? 1,
        lastRound: json["lastRound"] ?? 1,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "dataId": dataId,
        "exerciseCountList": exerciseCountList,
        "lastExerciseCount": lastExerciseCount,
        "lastRound": lastRound,
      };
}
