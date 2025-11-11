import 'dart:convert';

List<DayHistoryModel> dayHistoryModelFromJson(String str) =>
    List<DayHistoryModel>.from(json.decode(str).map((x) => DayHistoryModel.fromJson(x)));

String dayHistoryModelToJson(List<DayHistoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DayHistoryModel {
  int? id;
  String? dataId;
  String? title;
  String? split;
  String? monthId;
  String? weekId;
  String? dayId;
  DateTime? date;
  String? status;
  DateTime? startTime;
  DateTime? endTime;
  String? type;
  String? completedExercise;
  String? totalWeight;

  DayHistoryModel({
    this.id,
    this.dataId,
    this.split,
    this.monthId,
    this.weekId,
    this.dayId,
    this.title,
    this.date,
    this.status,
    this.startTime,
    this.endTime,
    this.type,
    this.completedExercise,
    this.totalWeight,
  });

  factory DayHistoryModel.fromJson(Map<String, dynamic> json) {
    return DayHistoryModel(
      id: json["id"],
      dataId: json["dataId"],
      split: json["split"],
      monthId: json["monthId"],
      title: json["title"],
      weekId: json["weekId"],
      dayId: json["dayId"],
      date: json["date"] == null || json["date"] == "" || json["date"] == "null" ? null : DateTime.parse(json["date"]),
      status: json["status"],
      startTime:
          json["startTime"] == null || json["startTime"] == "" || json["startTime"] == "null" ? null : DateTime.parse(json["startTime"]),
      endTime: json["endTime"] == null || json["endTime"] == "" || json["endTime"] == "null" ? null : DateTime.parse(json["endTime"]),
      type: json["type"],
      completedExercise: json["completedExercise"],
      totalWeight: json["totalWeight"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "dataId": dataId,
        "title": title,
        "split": split,
        "monthId": monthId,
        "weekId": weekId,
        "dayId": dayId,
        "date": date?.toIso8601String(),
        "status": status,
        "startTime": startTime?.toIso8601String(),
        "endTime": endTime?.toIso8601String(),
        "type": type,
        "totalWeight": totalWeight,
        "completedExercise": completedExercise,
      };
}
