import 'dart:convert';

import 'package:bbb/pages/NewMonthView/MonthResponseModel/new_model.dart';

PumpDayModel pumpDayModelFromJson(String str) => PumpDayModel.fromJson(json.decode(str));

String pumpDayModelToJson(PumpDayModel data) => json.encode(data.toJson());

class PumpDayModel {
  String? id;
  int? typeId;
  String? title;
  String? description;
  String? vimeoId;
  dynamic thumbnail;
  List<String>? formats;
  List<WarmupDataModel>? warmups;
  List<ExerciseDataModel>? exercises;
  List<PumpCircuit>? circuits;
  int? v;

  PumpDayModel({
    this.id,
    this.typeId,
    this.title,
    this.description,
    this.vimeoId,
    this.thumbnail,
    this.formats,
    this.warmups,
    this.exercises,
    this.circuits,
    this.v,
  });

  factory PumpDayModel.fromJson(Map<String, dynamic> json) => PumpDayModel(
        id: json["_id"],
        typeId: json["typeId"],
        title: json["title"],
        description: json["description"],
        vimeoId: json["vimeoId"],
        thumbnail: json["thumbnail"],
        formats: json["formats"] == null ? [] : List<String>.from(json["formats"]!.map((x) => x)),
        warmups: json["warmups"] == null ? [] : List<WarmupDataModel>.from(json["warmups"]!.map((x) => WarmupDataModel.fromJson(x))),
        exercises:
            json["exercises"] == null ? [] : List<ExerciseDataModel>.from(json["exercises"]!.map((x) => ExerciseDataModel.fromJson(x))),
        circuits: json["circuits"] == null ? [] : List<PumpCircuit>.from(json["circuits"]!.map((x) => PumpCircuit.fromJson(x))),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "typeId": typeId,
        "title": title,
        "description": description,
        "vimeoId": vimeoId,
        "thumbnail": thumbnail,
        "formats": formats == null ? [] : List<dynamic>.from(formats!.map((x) => x)),
        "warmups": warmups == null ? [] : List<dynamic>.from(warmups!.map((x) => x.toJson())),
        "exercises": exercises == null ? [] : List<dynamic>.from(exercises!.map((x) => x.toJson())),
        "circuits": circuits == null ? [] : List<dynamic>.from(circuits!.map((x) => x.toJson())),
        "__v": v,
      };
}

class PumpCircuit {
  int? round;
  int? typeId;
  List<String>? formats;
  List<ExerciseDataModel>? circuitExercises;
  String? id;
  int? selectedDot;

  PumpCircuit({
    this.round,
    this.typeId,
    this.formats,
    this.circuitExercises,
    this.id,
    this.selectedDot,
  });

  factory PumpCircuit.fromJson(Map<String, dynamic> json) => PumpCircuit(
        round: json["round"],
        typeId: json["typeId"],
        formats: json["formats"] == null ? [] : List<String>.from(json["formats"]!.map((x) => x)),
        circuitExercises: json["circuitExercises"] == null
            ? []
            : List<ExerciseDataModel>.from(json["circuitExercises"]!.map((x) => ExerciseDataModel.fromJson(x))),
        id: json["_id"],
        selectedDot: json["selectedDot"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "round": round,
        "typeId": typeId,
        "formats": formats == null ? [] : List<dynamic>.from(formats!.map((x) => x)),
        "circuitExercises": circuitExercises == null ? [] : List<dynamic>.from(circuitExercises!.map((x) => x.toJson())),
        "_id": id,
        "selectedDot": selectedDot,
      };
}
