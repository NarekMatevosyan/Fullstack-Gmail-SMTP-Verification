import 'dart:convert';

List<MonthResponseModel> monthResponseModelFromJson(String str) =>
    List<MonthResponseModel>.from(json.decode(str).map((x) => MonthResponseModel.fromJson(x)));

String monthResponseModelToJson(List<MonthResponseModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MonthResponseModel {
  int? id;
  String? monthId;
  String? monthStartDate;
  String? monthEndDate;

  MonthResponseModel({
    this.id,
    this.monthId,
    this.monthStartDate,
    this.monthEndDate,
  });

  factory MonthResponseModel.fromJson(Map<String, dynamic> json) => MonthResponseModel(
        id: json["id"],
        monthId: json["monthId"],
        monthStartDate: json["monthStartDate"],
        monthEndDate: json["monthEndDate"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "monthId": monthId,
        "monthStartDate": monthStartDate,
        "monthEndDate": monthEndDate,
      };
}
