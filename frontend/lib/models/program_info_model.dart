// To parse this JSON data, do
//
//     final programInfoModel = programInfoModelFromJson(jsonString);

import 'dart:convert';

ProgramInfoModel programInfoModelFromJson(String str) => ProgramInfoModel.fromJson(json.decode(str));

String programInfoModelToJson(ProgramInfoModel data) => json.encode(data.toJson());

class ProgramInfoModel {
  int count;
  List<Section> sections;

  ProgramInfoModel({
    required this.count,
    required this.sections,
  });

  factory ProgramInfoModel.fromJson(Map<String, dynamic> json) => ProgramInfoModel(
    count: json["count"],
    sections: List<Section>.from(json["sections"].map((x) => Section.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "sections": List<dynamic>.from(sections.map((x) => x.toJson())),
  };
}

class Section {
  String id;
  String title;
  String description;
  String vimeoId;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  Section({
    required this.id,
    required this.title,
    required this.description,
    required this.vimeoId,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Section.fromJson(Map<String, dynamic> json) => Section(
    id: json["_id"],
    title: json["title"],
    description: json["description"],
    vimeoId: json["vimeoId"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "description": description,
    "vimeoId": vimeoId,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}
