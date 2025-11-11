import 'dart:convert';

class SplitType {
  static const String split3 = "split3";
  static const String split4 = "split4";
  static const String split5 = "split5";
}

MonthDataModel monthDataModelFromJson(String str) => MonthDataModel.fromJson(json.decode(str));

String monthDataModelToJson(MonthDataModel data) => json.encode(data.toJson());

class MonthDataModel {
  String? id;
  int? index;
  String? title;
  String? description;
  String? vimeoId;
  String? thumbnail;
  DateTime? startDate;
  DateTime? endDate;
  List<WeekDataModel>? weeks;
  int? v;

  MonthDataModel(
      {this.id, this.index, this.title, this.description, this.vimeoId, this.thumbnail, this.startDate, this.endDate, this.weeks, this.v});

  factory MonthDataModel.fromJson(Map<String, dynamic> json) => MonthDataModel(
        id: json["_id"],
        index: json["index"],
        title: json["title"],
        description: json["description"],
        vimeoId: json["vimeoId"],
        thumbnail: json["thumbnail"],
        startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
        endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        weeks: json["weeks"] == null ? [] : List<WeekDataModel>.from(json["weeks"]!.map((x) => WeekDataModel.fromJson(x))),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "index": index,
        "title": title,
        "description": description,
        "vimeoId": vimeoId,
        "thumbnail": thumbnail,
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
        "weeks": weeks == null ? [] : List<dynamic>.from(weeks!.map((x) => x.toJson())),
        "__v": v,
      };
}

class WeekDataModel {
  int? index;
  String? title;
  String? description;
  String? vimeoId;
  String? thumbnail;
  String? restdayId;
  List<String>? pumpDayIds;
  List<DayDataModel>? days;
  String? id;
  List? dayList;
  List? idList;

  WeekDataModel({
    this.index,
    this.title,
    this.description,
    this.vimeoId,
    this.thumbnail,
    this.restdayId,
    this.pumpDayIds,
    this.days,
    this.id,
    this.dayList,
    this.idList,
  });

  factory WeekDataModel.fromJson(Map<String, dynamic> json) => WeekDataModel(
        index: json["index"],
        title: json["title"],
        description: json["description"],
        vimeoId: json["vimeoId"],
        thumbnail: json["thumbnail"],
        restdayId: json["restdayId"],
        pumpDayIds: json["pumpDayIds"].runtimeType.toString() == "String"
            ? json["pumpDayIds"].toString().split(',').toList()
            : json["pumpDayIds"] == null
                ? []
                : List<String>.from(json["pumpDayIds"]!.map((x) => x)),
        days: json["days"] == null ? [] : List<DayDataModel>.from(json["days"]!.map((x) => DayDataModel.fromJson(x))),
        id: json["_id"] ?? json["id"],
        dayList: json["dayList"] ?? [],
        idList: json["idList"] ?? [],
      );

  Map<String, dynamic> toJson() => {
        "index": index,
        "title": title,
        "description": description,
        "vimeoId": vimeoId,
        "thumbnail": thumbnail,
        "restdayId": restdayId,
        "pumpDayIds": pumpDayIds.runtimeType.toString() == "String"
            ? pumpDayIds.toString().split(',').toList()
            : pumpDayIds == null
                ? []
                : List<dynamic>.from(pumpDayIds!.map((x) => x)),
        "days": days == null ? [] : List<dynamic>.from(days!.map((x) => x.toJson())),
        "_id": id,
        "dayList": dayList,
        "idList": idList
      };
}

class DayDataModel {
  int? typeId;
  String? title;
  String? description;
  String? vimeoId;
  dynamic thumbnail;
  List<String>? formats;
  List<WarmupDataModel>? warmups;
  List<ExerciseDataModel>? exercises;
  String? id;

  String? dayType;

  DayDataModel({
    this.typeId,
    this.title,
    this.description,
    this.vimeoId,
    this.thumbnail,
    this.formats,
    this.warmups,
    this.exercises,
    this.id,
    this.dayType,
  });

  factory DayDataModel.fromJson(Map<String, dynamic> json) => DayDataModel(
        typeId: json["typeId"],
        title: json["title"],
        description: json["description"],
        vimeoId: json["vimeoId"],
        thumbnail: json["thumbnail"],
        formats: json["formats"].runtimeType.toString() == "String"
            ? json["formats"].toString().split(',').toList()
            : json["formats"] == null
                ? []
                : List<String>.from(json["formats"].map((x) => x)),
        warmups: json["warmups"] == null ? [] : List<WarmupDataModel>.from(json["warmups"]!.map((x) => WarmupDataModel.fromJson(x))),
        exercises:
            json["exercises"] == null ? [] : List<ExerciseDataModel>.from(json["exercises"]!.map((x) => ExerciseDataModel.fromJson(x))),
        id: json["id"] ?? json["_id"],
        dayType: json["dayType"],
      );

  Map<String, dynamic> toJson() => {
        "typeId": typeId,
        "title": title,
        "description": description,
        "vimeoId": vimeoId,
        "thumbnail": thumbnail,
        "formats": formats.runtimeType.toString() == "String"
            ? formats.toString().split(',').toList()
            : formats == null
                ? []
                : List<dynamic>.from(formats!.map((x) => x)),
        "warmups": warmups == null ? [] : List<dynamic>.from(warmups!.map((x) => x.toJson())),
        "exercises": exercises == null ? [] : List<dynamic>.from(exercises!.map((x) => x.toJson())),
        "_id": id,
        "dayType": dayType,
      };
}

class ExerciseDataModel {
  int? typeId;
  String? exerciseId;
  String? name;
  String? guide;
  int? sets;
  int? reps;
  int? weight;
  int? rest;
  List<String>? formats;
  List<ExtraDataModel>? extra;
  String? id;

  ExerciseDataModel(
      {this.typeId,
      this.exerciseId,
      this.name,
      this.guide,
      this.sets,
      this.reps,
      this.weight,
      this.rest,
      this.formats,
      this.extra,
      this.id});

  factory ExerciseDataModel.fromJson(Map<String, dynamic> json) => ExerciseDataModel(
        typeId: json["typeId"],
        exerciseId: json["exerciseId"],
        name: json["name"] ?? json["title"],
        guide: json["guide"],
        sets: json["sets"],
        reps: json["reps"],
        weight: json["weight"],
        rest: json["rest"],
        formats: json["formats"].runtimeType.toString() == "String"
            ? json["formats"].toString().split(',').toList()
            : json["formats"] == null
                ? []
                : List<String>.from(json["formats"]!.map((x) => x)),
        extra: json["extra"] == null ? [] : List<ExtraDataModel>.from(json["extra"]!.map((x) => ExtraDataModel.fromJson(x))),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "typeId": typeId,
        "exerciseId": exerciseId,
        "name": name,
        "guide": guide,
        "sets": sets,
        "reps": reps,
        "weight": weight,
        "rest": rest,
        "formats": formats.runtimeType.toString() == "String"
            ? formats.toString().split(',').toList()
            : formats == null
                ? []
                : List<dynamic>.from(formats!.map((x) => x)),
        "extra": extra == null ? [] : List<dynamic>.from(extra!.map((x) => x.toJson())),
        "_id": id,
      };
}

class ExtraDataModel {
  int? sets;
  int? reps;
  int? weight;
  int? rest;
  int? load;
  int? type;
  String? id;

  ExtraDataModel({
    this.sets,
    this.reps,
    this.weight,
    this.rest,
    this.load,
    this.type,
    this.id,
  });

  factory ExtraDataModel.fromJson(Map<String, dynamic> json) => ExtraDataModel(
        sets: json["sets"] ?? 0,
        reps: json["reps"] ?? 0,
        weight: json["weight"] ?? 0,
        rest: json["rest"] ?? 0,
        load: json["load"] ?? 0,
        type: json["type"] ?? 0,
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

class WarmupDataModel {
  int? typeId;
  String? warmupId;
  String? title;
  String? guide;
  List<String>? formats;
  String? id;

  WarmupDataModel({
    this.typeId,
    this.warmupId,
    this.title,
    this.guide,
    this.formats,
    this.id,
  });

  factory WarmupDataModel.fromJson(Map<String, dynamic> json) => WarmupDataModel(
        typeId: json["typeId"],
        warmupId: json["warmupId"],
        title: json["title"],
        guide: json["guide"],
        formats: json["formats"].runtimeType.toString() == "String"
            ? json["formats"].toString().split(',').toList()
            : json["formats"] == null
                ? []
                : List<String>.from(json["formats"]!.map((x) => x)),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "typeId": typeId,
        "warmupId": warmupId,
        "title": title,
        "guide": guide,
        "formats": formats.runtimeType.toString() == "String"
            ? formats.toString().split(',').toList()
            : formats == null
                ? []
                : List<dynamic>.from(formats!.map((x) => x)),
        "_id": id,
      };
}
