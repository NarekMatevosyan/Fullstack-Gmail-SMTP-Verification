// To parse this JSON data, do
//
//     final city = cityFromJson(jsonString);

import 'dart:convert';

List<City> cityFromJson(String str) => List<City>.from(json.decode(str).map((x) => City.fromJson(x)));

String cityToJson(List<City> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class City {
  String cityName;

  City({
    required this.cityName,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
    cityName: json["city_name"],
  );

  Map<String, dynamic> toJson() => {
    "city_name": cityName,
  };
}
