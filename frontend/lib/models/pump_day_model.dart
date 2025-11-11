// To parse this JSON data, do
//
//     final pumpDayModel = pumpDayModelFromJson(jsonString);

import 'dart:convert';

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
  List<Warmup>? warmups;
  List<Exercise>? exercises;
  List<Circuit>? circuits;
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
    warmups: json["warmups"] == null ? [] : List<Warmup>.from(json["warmups"]!.map((x) => Warmup.fromJson(x))),
    exercises: json["exercises"] == null ? [] : List<Exercise>.from(json["exercises"]!.map((x) => Exercise.fromJson(x))),
    circuits: json["circuits"] == null ? [] : List<Circuit>.from(json["circuits"]!.map((x) => Circuit.fromJson(x))),
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

class Circuit {
  int? round;
  int? typeId;
  List<String>? formats;
  List<Exercise>? circuitExercises;
  String? id;

  Circuit({
    this.round,
    this.typeId,
    this.formats,
    this.circuitExercises,
    this.id,
  });

  factory Circuit.fromJson(Map<String, dynamic> json) => Circuit(
    round: json["round"],
    typeId: json["typeId"],
    formats: json["formats"] == null ? [] : List<String>.from(json["formats"]!.map((x) => x)),
    circuitExercises: json["circuitExercises"] == null ? [] : List<Exercise>.from(json["circuitExercises"]!.map((x) => Exercise.fromJson(x))),
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "round": round,
    "typeId": typeId,
    "formats": formats == null ? [] : List<dynamic>.from(formats!.map((x) => x)),
    "circuitExercises": circuitExercises == null ? [] : List<dynamic>.from(circuitExercises!.map((x) => x.toJson())),
    "_id": id,
  };
}

class Exercise {
  String? exerciseId;
  String? guide;
  int? sets;
  int? reps;
  String? name;
  int? weight;
  int? rest;
  List<dynamic>? formats;
  List<Extra>? extra;
  String? id;
  int? typeId;

  Exercise({
    this.exerciseId,
    this.guide,
    this.sets,
    this.reps,
    this.name,
    this.weight,
    this.rest,
    this.formats,
    this.extra,
    this.id,
    this.typeId,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
    exerciseId: json["exerciseId"],
    guide: json["guide"],
    sets: json["sets"],
    reps: json["reps"],
    name: json["name"],
    weight: json["weight"],
    rest: json["rest"],
    formats: json["formats"] == null ? [] : List<dynamic>.from(json["formats"]!.map((x) => x)),
    extra: json["extra"] == null ? [] : List<Extra>.from(json["extra"]!.map((x) => Extra.fromJson(x))),
    id: json["_id"],
    typeId: json["typeId"],
  );

  Map<String, dynamic> toJson() => {
    "exerciseId": exerciseId,
    "guide": guide,
    "sets": sets,
    "reps": reps,
    "name": name,
    "weight": weight,
    "rest": rest,
    "formats": formats == null ? [] : List<dynamic>.from(formats!.map((x) => x)),
    "extra": extra == null ? [] : List<dynamic>.from(extra!.map((x) => x.toJson())),
    "_id": id,
    "typeId": typeId,
  };
}

class Extra {
  int? sets;
  int? reps;
  int? weight;
  int? rest;
  int? load;
  int? type;
  String? id;

  Extra({
    this.sets,
    this.reps,
    this.weight,
    this.rest,
    this.load,
    this.type,
    this.id,
  });

  factory Extra.fromJson(Map<String, dynamic> json) => Extra(
    sets: json["sets"],
    reps: json["reps"],
    weight: json["weight"],
    rest: json["rest"],
    load: json["load"],
    type: json["type"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "sets": sets,
    "reps": reps,
    "weight": weight,
    "rest": rest,
    "load": load,
    "type": type,
    "_id": id,
  };
}

class Warmup {
  int? typeId;
  String? warmupId;
  String? title;
  String? guide;
  List<dynamic>? formats;
  String? id;

  Warmup({
    this.typeId,
    this.warmupId,
    this.title,
    this.guide,
    this.formats,
    this.id,
  });

  factory Warmup.fromJson(Map<String, dynamic> json) => Warmup(
    typeId: json["typeId"],
    warmupId: json["warmupId"],
    title: json["title"],
    guide: json["guide"],
    formats: json["formats"] == null ? [] : List<dynamic>.from(json["formats"]!.map((x) => x)),
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "typeId": typeId,
    "warmupId": warmupId,
    "title": title,
    "guide": guide,
    "formats": formats == null ? [] : List<dynamic>.from(formats!.map((x) => x)),
    "_id": id,
  };
}
