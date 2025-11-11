import 'dart:convert';

RestDayModel restDayModelFromJson(String str) => RestDayModel.fromJson(json.decode(str));

String restDayModelToJson(RestDayModel data) => json.encode(data.toJson());

class RestDayModel {
  String? id;
  String? title;
  String? vimeoId;
  String? description;
  List<String>? equipments;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? restDayModelId;

  RestDayModel({
    this.id,
    this.title,
    this.vimeoId,
    this.description,
    this.equipments,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.restDayModelId,
  });

  factory RestDayModel.fromJson(Map<String, dynamic> json) => RestDayModel(
        id: json["_id"],
        title: json["title"],
        vimeoId: json["vimeoId"],
        description: json["description"],
        equipments: json["equipments"] == null ? [] : List<String>.from(json["equipments"]!.map((x) => x)),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        restDayModelId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "vimeoId": vimeoId,
        "description": description,
        "equipments": equipments == null ? [] : List<dynamic>.from(equipments!.map((x) => x)),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "id": restDayModelId,
      };
}
