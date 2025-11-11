import 'dart:convert';

List<HistoryDataModel> historyDataModelFromJson(String str) =>
    List<HistoryDataModel>.from(json.decode(str).map((x) => HistoryDataModel.fromJson(x)));

String historyDataModelToJson(List<HistoryDataModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HistoryDataModel {
  int? id;
  String? dataId;
  String? exerciseId;
  String? extraId;
  String? dayId;
  String? monthId;
  String? sets;
  String? reps;
  String? weight;
  String? rest;
  String? load;
  String? type;
  String? effort;
  String? date;
  int? index;
  int? subIndex;
  String? status;
  String? split;

  HistoryDataModel({
    this.id,
    this.dataId,
    this.exerciseId,
    this.extraId,
    this.sets,
    this.reps,
    this.weight,
    this.rest,
    this.load,
    this.type,
    this.effort,
    this.date,
    this.index,
    this.subIndex,
    this.status,
    this.monthId,
    this.dayId,
    this.split,
  });

  factory HistoryDataModel.fromJson(Map<String, dynamic> json) => HistoryDataModel(
        id: json["id"],
        dataId: json["dataId"],
        exerciseId: json["exerciseId"],
        extraId: json["extraId"],
        sets: json["sets"],
        reps: json["reps"],
        weight: json["weight"],
        rest: json["rest"],
        load: json["load"],
        type: json["type"],
        effort: json["effort"],
        date: json["date"] ?? "",
        index: json["index"],
        subIndex: json["subIndex"],
        status: json["status"],
        monthId: json["monthId"],
        dayId: json["dayId"],
        split: json["split"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "split": split,
        "dataId": dataId,
        "exerciseId": exerciseId,
        "extraId": extraId,
        "sets": sets,
        "reps": reps,
        "weight": weight,
        "rest": rest,
        "load": load,
        "type": type,
        "effort": effort,
        "date": date,
        "index": index,
        "subIndex": subIndex,
        "status": status,
        "monthId": monthId,
        "dayId": dayId,
      };
}
