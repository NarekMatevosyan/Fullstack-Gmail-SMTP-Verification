import 'dart:convert';

WarmUpModel warmUpModelFromJson(String str) => WarmUpModel.fromJson(json.decode(str));

String warmUpModelToJson(WarmUpModel data) => json.encode(data.toJson());

class WarmUpModel {
  String? id;
  String? title;
  String? vimeoId;
  String? description;
  List<String>? equipments;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  int? length;
  String? thumbnail;
  List<FileElement>? files;

  WarmUpModel({
    this.id,
    this.title,
    this.vimeoId,
    this.description,
    this.equipments,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.length,
    this.thumbnail,
    this.files,
  });

  factory WarmUpModel.fromJson(Map<String, dynamic> json) => WarmUpModel(
        id: json["_id"],
        title: json["title"],
        vimeoId: json["vimeoId"],
        description: json["description"],
        equipments: json["equipments"] == null ? [] : List<String>.from(json["equipments"]!.map((x) => x)),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        length: json["length"],
        thumbnail: json["thumbnail"],
        files: json["files"] == null ? [] : List<FileElement>.from(json["files"]!.map((x) => FileElement.fromJson(x))),
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
        "length": length,
        "thumbnail": thumbnail,
        "files": files == null ? [] : List<dynamic>.from(files!.map((x) => x.toJson())),
      };
}

class FileElement {
  String? quality;
  String? rendition;
  String? type;
  int? width;
  int? height;
  String? link;
  DateTime? createdTime;
  int? fps;
  int? size;
  dynamic md5;
  String? publicName;
  String? sizeShort;

  FileElement({
    this.quality,
    this.rendition,
    this.type,
    this.width,
    this.height,
    this.link,
    this.createdTime,
    this.fps,
    this.size,
    this.md5,
    this.publicName,
    this.sizeShort,
  });

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
        quality: json["quality"],
        rendition: json["rendition"],
        type: json["type"],
        width: json["width"],
        height: json["height"],
        link: json["link"],
        createdTime: json["created_time"] == null ? null : DateTime.parse(json["created_time"]),
        fps: json["fps"],
        size: json["size"],
        md5: json["md5"],
        publicName: json["public_name"],
        sizeShort: json["size_short"],
      );

  Map<String, dynamic> toJson() => {
        "quality": quality,
        "rendition": rendition,
        "type": type,
        "width": width,
        "height": height,
        "link": link,
        "created_time": createdTime?.toIso8601String(),
        "fps": fps,
        "size": size,
        "md5": md5,
        "public_name": publicName,
        "size_short": sizeShort,
      };
}
