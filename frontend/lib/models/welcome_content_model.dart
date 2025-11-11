// To parse this JSON data, do
//
//     final welcomeContentModel = welcomeContentModelFromJson(jsonString);

import 'dart:convert';

WelcomeContentModel welcomeContentModelFromJson(String str) => WelcomeContentModel.fromJson(json.decode(str));

String welcomeContentModelToJson(WelcomeContentModel data) => json.encode(data.toJson());

class WelcomeContentModel {
  String id;
  int v;
  DateTime createdAt;
  DateTime updatedAt;
  String vimeoId;
  String imgUrl;
  List<Slide> slides;
  String welcomeContentModelId;

  WelcomeContentModel({
    required this.id,
    required this.v,
    required this.createdAt,
    required this.updatedAt,
    required this.vimeoId,
    required this.imgUrl,
    required this.slides,
    required this.welcomeContentModelId,
  });

  factory WelcomeContentModel.fromJson(Map<String, dynamic> json) => WelcomeContentModel(
    id: json["_id"],
    v: json["__v"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    vimeoId: json["vimeoId"],
    imgUrl: json["imgUrl"],
    slides: List<Slide>.from(json["slides"].map((x) => Slide.fromJson(x))),
    welcomeContentModelId: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "__v": v,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "vimeoId": vimeoId,
    "imgUrl": imgUrl,
    "slides": List<dynamic>.from(slides.map((x) => x.toJson())),
    "id": welcomeContentModelId,
  };
}

class Slide {
  String title;
  String description;
  String id;

  Slide({
    required this.title,
    required this.description,
    required this.id,
  });

  factory Slide.fromJson(Map<String, dynamic> json) => Slide(
    title: json["title"],
    description: json["description"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "_id": id,
  };
}
