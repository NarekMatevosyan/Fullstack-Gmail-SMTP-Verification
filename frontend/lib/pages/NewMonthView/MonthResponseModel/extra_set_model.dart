// To parse this JSON data, do
//
//     final extraSetModel = extraSetModelFromJson(jsonString);

import 'dart:convert';

List<ExtraSetModel> extraSetModelFromJson(String str) => List<ExtraSetModel>.from(json.decode(str).map((x) => ExtraSetModel.fromJson(x)));

String extraSetModelToJson(List<ExtraSetModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ExtraSetModel {
  int? id;
  String? dataId;
  int? sets;
  int? reps;
  int? weight;
  int? rest;
  int? load;
  int? type;
  String? extraId;
  String? date;

  ExtraSetModel({
    this.id,
    this.dataId,
    this.sets,
    this.reps,
    this.weight,
    this.rest,
    this.load,
    this.type,
    this.extraId,
    this.date,
  });

  factory ExtraSetModel.fromJson(Map<String, dynamic> json) => ExtraSetModel(
        id: json["id"],
        dataId: json["dataId"],
        sets: json["sets"],
        reps: json["reps"],
        weight: json["weight"],
        rest: json["rest"],
        load: json["load"],
        type: json["type"],
        extraId: json["extraId"],
        date: json["date"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "dataId": dataId,
        "sets": sets,
        "reps": reps,
        "weight": weight,
        "rest": rest,
        "load": load,
        "type": type,
        "extraId": extraId,
        "date": date,
      };
}
